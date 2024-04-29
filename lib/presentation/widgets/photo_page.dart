import 'dart:async';
import 'dart:io';
import 'package:baflutter2/presentation/widgets/image_display_page.dart';
import 'package:baflutter2/presentation/widgets/take_picture.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  void initState() async {
    super.initState();
    await _loadImages();
  }

  final List<File> _images = [];

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
        onPressed: () => _openCamera(),
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> _openCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

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
  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final List<File> images = [];

    // Alle Files auflisten
    final fileList = directory.listSync();
    for (var file in fileList) {
      if (file.path.endsWith('.jpg') || file.path.endsWith('.png')) {
        images.add(File(file.path));
      }
    }

    // State mit neu geladenen Bildern updaten
    setState(() {
      _images.addAll(images);
    });
  }

  void updateImageList(File updatedImage) {
    int index = _images.indexWhere((img) => img.path == updatedImage.path);
    if (index != -1) {
      setState(() {
        _images[index] = updatedImage;
      });
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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

  void _deleteImage(File imageFile, int index) {
    setState(() {
      _images.removeAt(index);
      imageFile.deleteSync(); // Löscht die Datei synchron aus dem Dateisystem
    });
  }
}
