import 'dart:io';
import 'package:flutter/material.dart';

class PhotoPreviewWidget extends StatefulWidget {
  final List<String?> imageUrls;
  final Function(List<String?>) updateImagesCallback;

  PhotoPreviewWidget(
      {required this.imageUrls, required this.updateImagesCallback});

  @override
  _PhotoPreviewWidgetState createState() => _PhotoPreviewWidgetState();
}

class _PhotoPreviewWidgetState extends State<PhotoPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return Center(child: Text("Keine Bilder ausgewählt."));
    }

    return ReorderableListView.builder(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          // Arbeiten Sie mit einer Kopie der Liste
          final List<String?> updatedImageUrls =
              List<String?>.from(widget.imageUrls);
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final String? movedImage = updatedImageUrls.removeAt(oldIndex);
          updatedImageUrls.insert(newIndex, movedImage);
          widget.updateImagesCallback(updatedImageUrls);
        });
      },
      itemBuilder: (BuildContext context, int index) {
        final imageUrl = widget.imageUrls[index];

        if (imageUrl != null && imageUrl.isNotEmpty) {
          return Container(
            key: ValueKey(imageUrl),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: Image.file(File(imageUrl)), // Geändert zu Image.file
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    widget.imageUrls.remove(imageUrl);
                    widget.updateImagesCallback(widget.imageUrls);
                  },
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
      itemCount: widget.imageUrls.length,
    );
  }
}
