import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:baflutter2/presentation/widgets/image_display_page.dart';
import 'package:baflutter2/presentation/widgets/take_picture.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final Logger logger = Logger();

  final List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fotogalerie"),
      ),
      body: _images.isEmpty
          ? const Center(child: Text("Keine Fotos vorhanden."))
          : ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return ListTile(
                  minVerticalPadding: 20.0,
                  leading: Image.file(_images[index],
                      width: 100, height: 100, fit: BoxFit.cover),
                  title: Text("Foto ${index + 1}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageDisplayPage(imageFile: _images[index]),
                      ),
                    );
                  },
                  onLongPress: () =>
                      _loeschenDialog(context, _images[index], index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCamera,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> _openCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      if (!mounted) return;
      final result = await Navigator.push<File>(
        context,
        MaterialPageRoute(
          builder: (context) => TakePicture(camera: firstCamera),
        ),
      );

      if (result != null) {
        setState(() {
          _images.add(result);
        });
      }
    } catch (e) {
      logger.e('Fehler beim Öffnen der Kamera: $e');
    }
  }

  Future<void> _loadImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final List<File> images = [];

      // List all files in the directory
      final fileList = directory.listSync();
      for (var file in fileList) {
        if (file.path.endsWith('.jpg') || file.path.endsWith('.png')) {
          images.add(File(file.path));
        }
      }

      setState(() {
        _images.addAll(images);
      });
    } catch (e) {
      logger.e('Fehler beim Laden der Bilder: $e');
    }
  }

  void _loeschenDialog(BuildContext context, File imageFile, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Foto löschen'),
          content: const Text('Möchten Sie dieses Foto wirklich löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Löschen'),
              onPressed: () {
                _deleteImage(imageFile, index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteImage(File imageFile, int index) async {
    try {
      await imageFile.delete();
      setState(() {
        _images.removeAt(index);
      });
    } catch (e) {
      logger.e('Fehler beim Löschen der Datei: $e');
    }
  }
}
