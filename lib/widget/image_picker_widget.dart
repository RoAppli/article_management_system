import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImagePickerWidget extends StatefulWidget {
  final ValueChanged<List<String?>> onImagesSelected;
  final String articleId;
  final String id;

  ImagePickerWidget(
      {super.key,
      required this.onImagesSelected,
      required this.articleId,
      required this.id});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<Uint8List> _selectedImageUrls = [];

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      final pickedImages = result.files;

      List<String?> imageUrls = [];
      int i = 1;
      for (final file in pickedImages) {
        // Pfad des Originalbildes
        final originalImagePath = file.path;

        // Überprüfen, ob der Dateipfad existiert
        if (originalImagePath != null) {
          final File originalImageFile = File(originalImagePath);
          // Neuen Pfad für das Bild generieren
          var directory = await getApplicationDocumentsDirectory();
          var parentPath = path.join(directory.path, "Teppichklinik Berlin");
          await Directory(parentPath).create(recursive: true);
          var folderPath = path.join(
            directory.path,
            "Teppichklinik Berlin",
            "Bilder",
            widget.id,
          );
          await Directory(folderPath).create(recursive: true);
          final String fileName = "Bild$i.png";
          final String newImagePath = path.join(folderPath, fileName);

          // Kopieren Sie das Bild an den neuen Pfad
          final File newImageFile = await originalImageFile.copy(newImagePath);

          // Fügen Sie den neuen Pfad zur Liste der Bild-URLs hinzu
          imageUrls.add(newImageFile.path);
          i++;
        }
      }

      // Aktualisieren Sie die Liste der ausgewählten Bilder
      widget.onImagesSelected(imageUrls);
    }
  }

  void _removeImage(Uint8List image) {
    setState(() {
      _selectedImageUrls.remove(image);
    });
    List<String?> imageUrls =
        _selectedImageUrls.map((image) => base64Encode(image)).toList();
    widget.onImagesSelected(imageUrls);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await _pickImages();
          },
          child: Text('Fotos auswählen'),
        ),
      ],
    );
  }
}
