import 'package:flutter/material.dart';

class AppLayout extends StatefulWidget {
  final Widget body;

  const AppLayout({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width < 600
          ? AppBar(
              title: Column(
                children: [
                  Text("Arikelmanagement System"),
                ],
              ),
              backgroundColor: Theme.of(context).primaryColor,
            )
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).primaryColor,
              title: HeaderHorizontal(),
            ),
      body: widget.body,
      drawer: MediaQuery.of(context).size.width < 600
          ? HeaderVerticalDrawer()
          : null,
    );
  }
}

class HeaderHorizontal extends StatefulWidget {
  HeaderHorizontal({Key? key}) : super(key: key);

  @override
  _HeaderHorizontalState createState() => _HeaderHorizontalState();
}

class _HeaderHorizontalState extends State<HeaderHorizontal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _menuButton("Alle Artikel",
              () => Navigator.pushNamed(context, '/showArticles')),
          _menuButton("Artikel hinzufügen",
              () => Navigator.pushNamed(context, '/createArticle')),
        ]),
      ],
    );
  }

  Widget _menuButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: InkWell(
        onTap: onPressed,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 10.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class HeaderVerticalDrawer extends StatefulWidget {
  HeaderVerticalDrawer({Key? key}) : super(key: key);

  @override
  _HeaderVerticalDrawerState createState() => _HeaderVerticalDrawerState();
}

class _HeaderVerticalDrawerState extends State<HeaderVerticalDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Alle Artikel'),
            onTap: () {
              Navigator.pushNamed(context, '/showArticles');
              Navigator.pop(context); // Schließt den Drawer
            },
          ),
          ListTile(
            title: const Text('Artikel anlegen'),
            onTap: () {
              Navigator.pushNamed(context, '/createArticle');
              Navigator.pop(context); // Schließt den Drawer
            },
          ),
        ],
      ),
    );
  }
}
