import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class ImageDisplayPage extends StatefulWidget {
  final File imageFile;

  const ImageDisplayPage({super.key, required this.imageFile});

  @override
  ImageDisplayPageState createState() => ImageDisplayPageState();
}

class ImageDisplayPageState extends State<ImageDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vollbildansicht'),
      ),
      body: Center(
        child: Image.file(widget.imageFile),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _editImage,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Future<void> _editImage() async {
    final editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditor(image: widget.imageFile),
      ),
    );

    if (editedImage != null && mounted) {
      try {
        await _updateImage(editedImage);
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        _showError(e.toString());
      }
    }
  }

  Future<void> _updateImage(dynamic editedImage) async {
    await widget.imageFile.writeAsBytes(editedImage);
    _evictImageFromCache();
  }

  void _evictImageFromCache() {
    Image.file(widget.imageFile).image.evict();
  }

  void _showError(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fehler'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
