import 'dart:io';
import 'package:article_management_system/model/article.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class DatabaseController {
  late Database database;

  Future<void> initDb() async {
    // Ermitteln Sie den Pfad zum Dokumentenverzeichnis des Benutzers
    final directory = await getApplicationDocumentsDirectory();

    // Erstellen Sie den gewünschten Verzeichnispfad
    final dbDirectoryPath =
        path.join(directory.path, 'Teppichklinik Berlin', 'Datenbank');
    final dbDirectory = Directory(dbDirectoryPath);

    // Erstellen Sie das Verzeichnis, falls es nicht existiert
    if (!await dbDirectory.exists()) {
      await dbDirectory.create(recursive: true);
    }

    // Speicherort der Datenbank
    String dbPath = path.join(dbDirectoryPath, 'teppich_klinik.db');

    // Öffnen Sie die Datenbank
    database = sqlite3.open(dbPath);

    // Erstellen Sie die Tabelle, wenn sie nicht existiert
    database.execute('''
      CREATE TABLE IF NOT EXISTS articles (
        articleId TEXT PRIMARY KEY,
        articleName TEXT,
        articleDescription TEXT,
        platforms TEXT,
        isAuction INTEGER,
        isSold INTEGER,
        photoIds TEXT,
        id TEXT
      )
    ''');

    database.execute('''
      CREATE TABLE IF NOT EXISTS platforms (
        platformId INTEGER PRIMARY KEY,
        platformName TEXT UNIQUE
      )
    ''');

    await createPlatforms();
  }

  Future<void> createPlatform(String platform) async {
    database.execute('''
      INSERT OR IGNORE INTO platforms 
      (platformName)
      VALUES (?)
    ''', [platform]);
  }

  Future<void> createPlatforms() async {
    List<String> platforms = ["Ebay", "Amazon", "Kaufland", "Otto"];
    for (String platform in platforms) {
      database.execute('''
      INSERT OR IGNORE INTO platforms 
      (platformName)
      VALUES (?)
    ''', [platform]);
    }
  }

  Future<void> createArticle(Article article) async {
    database.execute('''
      INSERT INTO articles 
      (articleId, articleName, articleDescription, platforms, isAuction, isSold, photoIds, id)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      article.articleId,
      article.articleName,
      article.articleDescription,
      article.platforms.join(','),
      article.isAuction ? 1 : 0,
      article.isSold ? 1 : 0,
      article.photoIds.join(','),
      article.id
    ]);
  }

  Future<Article?> readArticle(String articleId) async {
    final result = database
        .select('SELECT * FROM articles WHERE articleId = ?', [articleId]);
    if (result.isNotEmpty) {
      final row = result.first;
      return Article(
          articleId: articleId,
          articleName: row['articleName'] as String,
          articleDescription: row['articleDescription'] as String,
          platforms: (row['platforms'] as String).split(','),
          isAuction: (row['isAuction'] as int) == 1,
          isSold: (row['isSold'] as int) == 1,
          photoIds: (row['photoIds'] as String).split(','),
          id: (row['id']));
    }
    return null;
  }

  Future<void> updateArticle(Article article) async {
    database.execute('''
      UPDATE articles SET 
      articleName = ?, articleDescription = ?, platforms = ?, isAuction = ?, isSold = ?, photoIds = ?
      WHERE articleId = ?
    ''', [
      article.articleName,
      article.articleDescription,
      article.platforms.join(','),
      article.isAuction ? 1 : 0,
      article.isSold ? 1 : 0,
      article.photoIds.join(','),
      article.articleId,
      article.id
    ]);
  }

  Future<void> updatePlatform(String oldName, String newName) async {
    database.execute('''
    UPDATE platforms SET platformName = ? WHERE platformName = ?
  ''', [newName, oldName]);
  }

  Future<void> deleteArticle(String articleId) async {
    database.execute('DELETE FROM articles WHERE articleId = ?', [articleId]);
  }

  Future<void> deletePlatform(String name) async {
    database.execute('DELETE FROM platforms WHERE platformName = ?', [name]);
  }

  Future<List<String>> getPlatforms() async {
    final result = database.select('SELECT platformName FROM platforms');
    return result.map((row) => row['platformName'] as String).toList();
  }

  Future<String> getArticleId() async {
    final today = DateTime.now();
    final dateString =
        DateFormat('yyyy.MM.dd').format(today); // Formatieren des Datums

    // Abfragen der Anzahl der Artikel, die heute erstellt wurden
    final result = database.select(
        "SELECT COUNT(*) AS count FROM articles WHERE articleId LIKE '$dateString.%'");
    int todayCount = result.first['count'] as int;

    // Generieren der neuen ID
    final id = '${dateString}.${(todayCount + 1).toString().padLeft(3, '0')}';
    return id;
  }

  Future<List<Article>> getArticles() async {
    final result = database.select('SELECT * FROM articles');
    return result.map((row) {
      return Article(
        articleId: row['articleId'] as String,
        articleName: row['articleName'] as String,
        articleDescription: row['articleDescription'] as String,
        platforms: (row['platforms'] as String).split(','),
        isAuction: (row['isAuction'] as int) == 1,
        isSold: (row['isSold'] as int) == 1,
        photoIds: (row['photoIds'] as String).split(','),
        id: (row['id']),
      );
    }).toList();
  }
}
