import 'dart:io';

import 'package:article_management_system/app_layout.dart';
import 'package:article_management_system/controller/database_controller.dart';
import 'package:article_management_system/model/article.dart';
import 'package:article_management_system/widget/image_picker_widget.dart';
import 'package:article_management_system/widget/photo_preview_widget.dart';
import 'package:article_management_system/widget/platform_selector.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:quill_html_converter/quill_html_converter.dart';

class CreateArticle extends StatefulWidget {
  const CreateArticle({Key? key}) : super(key: key);

  @override
  _CreateArticleState createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  String articleName = "";
  double articlePrice = 0.0;
  String description = "";
  late DatabaseController databaseController;

  // Aktualisierte Liste der Bild-URLs
  List<String?> _selectedImageUrls = [];
  late String articleId;
  late String folderPath;
  String id = "0";
  double length = 0.0;
  double width = 0.0;
  List<String> platforms = [];
  List<String> selectedPlatforms = [];
  late Future<void> _initialization;
  bool isAuction = false;
  QuillController _quillController = QuillController.basic();
  late Directory directory;
  late String parentPath;
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController lengthConroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialization = _prepareWidget();
    idController.addListener(() {
      setState(() {
        id = idController.text;
      });
    });
  }

  Future<void> _createFoldersForArticle(String articleId) async {
    directory = await getApplicationDocumentsDirectory();
    parentPath = path.join(directory.path, "Teppichklinik Berlin");
    await Directory(parentPath).create(recursive: true);
    folderPath = path.join(directory.path, id, "Teppichklinik Berlin");
  }

  Future<void> _loadArticleId() async {
    articleId = await databaseController.getArticleId();
  }

  Future<void> _prepareWidget() async {
    databaseController = DatabaseController();
    await databaseController.initDb();
    await _loadArticleId();
    await _createFoldersForArticle(articleId);
    await loadPlatforms(databaseController);
  }

  Future<void> loadPlatforms(DatabaseController dbController) async {
    List<String> fetchedPlatforms = await dbController.getPlatforms();
    setState(() {
      platforms = fetchedPlatforms;
    });
  }

  void updateImages(List<String?> images) {
    setState(() {
      _selectedImageUrls =
          images.where((imageUrl) => imageUrl != null).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Zeigen Sie einen Ladeindikator an, während auf die Daten gewartet wird
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Behandeln Sie Fehlerfälle
          return Center(child: Text('Fehler: ${snapshot.error}'));
        } else {
          // Die Daten sind geladen, bauen Sie das UI auf
          return Scaffold(
            body: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 600.0,
                            child: Column(
                              children: [
                                TextFormField(
                                  style: TextStyle(fontSize: 10.0),
                                  controller: nameController,
                                  decoration:
                                      InputDecoration(labelText: 'Artikelname'),
                                  onChanged: (value) {
                                    setState(() {
                                      articleName = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  style: TextStyle(fontSize: 10.0),
                                  controller: lengthConroller,
                                  decoration:
                                      InputDecoration(labelText: 'Länge'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      length = double.tryParse(value) ?? 0.0;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                TextFormField(
                                  style: TextStyle(fontSize: 10.0),
                                  controller: widthController,
                                  decoration:
                                      InputDecoration(labelText: 'Breite'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      width = double.tryParse(value) ?? 0.0;
                                    });
                                  },
                                ),
                                TextFormField(
                                  style: TextStyle(fontSize: 10.0),
                                  controller: priceController,
                                  decoration: InputDecoration(
                                      labelText: 'Artikelpreis'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      articlePrice =
                                          double.tryParse(value) ?? 0.0;
                                    });
                                  },
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  style: TextStyle(fontSize: 10.0),
                                  controller: idController,
                                  decoration: InputDecoration(labelText: 'ID'),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() async {
                                      id = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 16.0),
                                QuillProvider(
                                  configurations: QuillConfigurations(
                                    controller: _quillController,
                                    sharedConfigurations:
                                        const QuillSharedConfigurations(
                                      locale: Locale('de'),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const QuillToolbar(),
                                      Container(
                                        width: 600.0,
                                        height: 350.0,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.0,
                                                color:
                                                    const Color(0xff131313))),
                                        child: QuillEditor.basic(
                                          configurations:
                                              const QuillEditorConfigurations(
                                            readOnly: false,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ImagePickerWidget(
                            onImagesSelected: updateImages,
                            articleId: articleId,
                            id: id,
                          ),
                          Container(
                            width: 160.0,
                            height: 600.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff131313),
                                width: 1.0,
                              ),
                            ),
                            child: PhotoPreviewWidget(
                              imageUrls: _selectedImageUrls,
                              updateImagesCallback: updateImages,
                            ),
                          ),
                        ],
                      ),
                      Text("Bitte wählen Sie die Plattformen aus."),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: PlatformSelector(
                              platforms: platforms,
                              onSelectionChanged: handlePlatformSelection),
                        ),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: CheckboxListTile(
                            title: const Text(
                              'Ist es eine Auktion?',
                            ),
                            value: isAuction,
                            onChanged: (bool? value) {
                              setState(() {
                                isAuction = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity
                                .leading, // platziert die Checkbox vor dem Text
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: saveArticleToDatabase,
                          child: const Text("Artikel anlegen")),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void handlePlatformSelection(List<String> platforms) {
    setState(() {
      selectedPlatforms = platforms;
    });
  }

  Future<void> saveArticleToDatabase() async {
    description = _quillController.document.toDelta().toHtml();
    // Überprüfen Sie, ob alle notwendigen Felder ausgefüllt sind
    if (articleName.isEmpty) {
      _showSnackbar('Bitte geben Sie einen Artikelnamen ein.');
      return;
    }
    if (articlePrice <= 0) {
      _showSnackbar('Bitte geben Sie einen gültigen Preis ein.');
      return;
    }
    if (description == "") {
      _showSnackbar('Bitte geben Sie eine Artikelbeschreibung ein.');
      return;
    }
    if (selectedPlatforms.isEmpty) {
      _showSnackbar('Bitte wählen Sie mindestens eine Plattform aus.');
      return;
    }
    if (_selectedImageUrls.isEmpty) {
      _showSnackbar('Bitte fügen Sie mindestens ein Bild hinzu.');
      return;
    }

    // Erstelle eine neue Instanz von Article
    Article newArticle = Article(
        articleId: articleId,
        articleName: articleName,
        articleDescription: description,
        platforms: selectedPlatforms,
        isAuction: isAuction,
        isSold: false,
        photoIds: _selectedImageUrls
            .where((url) => url != null)
            .toList()
            .cast<String>(),
        id: id);

    // Rufen Sie die Methode createArticle auf, um den Artikel in der Datenbank zu speichern
    try {
      // await databaseController.createArticle(newArticle);
      await createAndInsertArticle(newArticle);
      _showSnackbar('Artikel erfolgreich gespeichert!');
      _resetForm();
    } catch (e) {
      _showSnackbar('Fehler beim Speichern des Artikels: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Methode zum Zurücksetzen des Zustands
  void _resetForm() {
    setState(() {
      articleName = "";
      articlePrice = 0.0;
      description = "";
      _selectedImageUrls.clear();
      selectedPlatforms.clear();
      isAuction = false;
      nameController.clear();
      lengthConroller.clear();
      widthController.clear();
      priceController.clear();
      idController.clear();
      _quillController.clear();
    });
  }

  Future<void> createAndInsertArticle(Article article) async {
    final directory = await getApplicationDocumentsDirectory();

    // Erstellen Sie den gewünschten Verzeichnispfad
    final excelDirectory =
        path.join(directory.path, 'Teppichklinik Berlin', 'Excel');
    final file = File(path.join(excelDirectory, 'articles.xlsx'));

    // Stellen Sie sicher, dass das Verzeichnis existiert
    await Directory(excelDirectory).create(recursive: true);
    var excel;
    if (await file.exists()) {
      // Datei existiert bereits, Excel-Objekt aus bestehender Datei laden
      var bytes = file.readAsBytesSync();
      excel = Excel.decodeBytes(bytes);
    } else {
      // Excel-Datei erstellen
      excel = Excel.createExcel();
    }

    // Arbeitsblatt auswählen oder erstellen
    Sheet sheetObject;
    sheetObject = excel['Articles'];

    // Überschriftenzeile hinzufügen
    sheetObject.appendRow([
      TextCellValue('ID'),
      TextCellValue('Artikelname'),
      TextCellValue('Länge'),
      TextCellValue('Breite'),
      TextCellValue('Preis'),
      TextCellValue('Beschreibung'),
      TextCellValue('Plattformen'),
      TextCellValue('Auktion'),
      TextCellValue('Verkauft'),
      TextCellValue('Foto-IDs'),
    ]);

    // Artikelinformationen hinzufügen
    sheetObject.appendRow([
      TextCellValue(article.id),
      TextCellValue(article.articleName),
      TextCellValue(length.toString()),
      TextCellValue(width.toString()),
      TextCellValue(articlePrice.toString()),
      TextCellValue(article.articleDescription),
      TextCellValue(article.platforms.join(', ')),
      TextCellValue(article.isAuction ? 'Ja' : 'Nein'),
      TextCellValue(article.isSold ? 'Ja' : 'Nein'),
      TextCellValue(article.photoIds.join(', ')),
    ]);

    // Excel-Datei speichern
    var data = excel.encode();
    file.writeAsBytesSync(data!);
  }
}
