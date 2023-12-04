import 'package:flutter/material.dart';

class PlatformSelector extends StatefulWidget {
  final List<String> platforms;
  final Function(List<String>) onSelectionChanged; // Callback

  const PlatformSelector(
      {super.key, required this.platforms, required this.onSelectionChanged});
  @override
  _PlatformSelectorState createState() => _PlatformSelectorState();
}

class _PlatformSelectorState extends State<PlatformSelector> {
  // Eine Liste zum Speichern der ausgewählten Plattformen
  List<String> selectedPlatforms = [];

  @override
  Widget build(BuildContext context) {
    // Erstellen einer Liste von CheckboxListTiles
    List<Widget> checkboxListTiles = [];
    for (int i = 0; i < widget.platforms.length; i += 2) {
      // Fügen Sie eine neue Zeile mit bis zu zwei Checkboxen hinzu
      List<Widget> rowChildren = [];
      for (int j = i; j < i + 2 && j < widget.platforms.length; j++) {
        rowChildren.add(
          Container(
            width: 300.0,
            child: CheckboxListTile(
              title: Text(
                widget.platforms[j],
              ),
              value: selectedPlatforms.contains(widget.platforms[j]),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedPlatforms.add(widget.platforms[j]);
                  } else {
                    selectedPlatforms.remove(widget.platforms[j]);
                  }
                  widget.onSelectionChanged(selectedPlatforms);
                });
              },
            ),
          ),
        );
      }
      checkboxListTiles.add(Row(children: rowChildren));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: checkboxListTiles,
    );
  }
}
