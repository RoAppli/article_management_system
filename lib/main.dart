import 'package:article_management_system/create_article.dart';
import 'package:article_management_system/show_articles.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const Color primaryColor = Color(0xffe7e7e7);
const Color appBarColor = Color(0xfffbfbfb);
const Color borderColor = Color(0xffe6e6e6);

final ThemeData amsTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: appBarColor,
  appBarTheme: AppBarTheme(
    color: appBarColor, // Verwendung der primären Farbe für die AppBar
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(appBarColor),
      foregroundColor: MaterialStateProperty.all(Colors.black),
      fixedSize: MaterialStateProperty.all<Size>(const Size(145, 16)),
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(
          fontSize: 10.0,
        ),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    // Grenze, wenn das TextFormField nicht fokussiert ist
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1.0),
    ),
    // Grenze, wenn das TextFormField fokussiert ist
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1.0),
    ),
    // Stil für den eingegebenen Text
    hintStyle: TextStyle(fontSize: 10.0),
    labelStyle: TextStyle(
        fontSize: 10.0), // Setzen Sie hier Ihre gewünschte Schriftgröße
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: amsTheme,
      home: const CreateArticle(),
      routes: {
        '/showArticles': (context) => ShowArticles(),
        '/createArticle': (context) => const CreateArticle(),
      },
    );
  }
}
