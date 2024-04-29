import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class TakePicture extends StatefulWidget {
  final CameraDescription camera;

  const TakePicture({super.key, required this.camera});

  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  CameraController? _controller;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _controller = CameraController(widget.camera, ResolutionPreset.high);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      logger.e("Fehler bei der Kamerainitialisierung: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Kamera')),
      body: CameraPreview(_controller!),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: () async {
          try {
            if (_controller == null || !_controller!.value.isInitialized) {
              logger.e("Kamera ist nicht initialisiert.");
              return;
            }
            final image = await _controller!.takePicture();
            final directory =
                await getApplicationDocumentsDirectory(); // Dauerhafter Speicherort
            final imagePath =
                '${directory.path}/${DateTime.now().toIso8601String()}.jpg';
            final imageFile = File(imagePath);
            await image.saveTo(imagePath);
            if (!mounted) return;
            Navigator.pop(context, imageFile);
          } catch (e) {
            logger.e("Fehler beim Foto machen: $e");
          }
        },
      ),
    );
  }
}
