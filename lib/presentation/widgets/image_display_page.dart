import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class ImageDisplayPage extends StatelessWidget {
  final File imageFile;

  const ImageDisplayPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vollbildansicht'),
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editImage(context),
        child: const Icon(Icons.edit),
      ),
    );
  }

  Future<void> _editImage(BuildContext context) async {
    final editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditor(image: imageFile),
      ),
    );

    if (editedImage != null) {
      await imageFile.writeAsBytes(editedImage);
      Image.file(imageFile).image.evict(); // Cache des Bildes löschen
      Navigator.pop(context);
    }
  }
}
