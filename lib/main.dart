import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

void main() => runApp(const MaterialApp(home: ImageDetectionPage()));

class ImageDetectionPage extends StatefulWidget {
  const ImageDetectionPage({super.key});

  @override
  State<ImageDetectionPage> createState() => _ImageDetectionPageState();
}

class _ImageDetectionPageState extends State<ImageDetectionPage> {
  File? _selectedImage;
  String _resultText = "Pick an image to start detection";
  final ImagePicker _picker = ImagePicker();

  // 1. Setup the Local Labeler
  final ImageLabeler _imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));

  Future<void> _processImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _resultText = "Analyzing...";
      });

      // 2. Convert file to ML Kit InputImage
      final inputImage = InputImage.fromFile(_selectedImage!);

      // 3. Run detection locally
      final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);

      // 4. Extract results
      String text = "I see:\n";
      for (ImageLabel label in labels) {
        text += "${label.label} (${(label.confidence * 100).toStringAsFixed(0)}%)\n";
      }

      setState(() {
        _resultText = labels.isEmpty ? "Could not detect anything" : text;
      });
    }
  }

  @override
  void dispose() {
    _imageLabeler.close(); // Always close to free up memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offline Image AI")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 300)
            else
              const Icon(Icons.image, size: 100, color: Colors.grey),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(_resultText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _processImage(ImageSource.gallery), child: const Text("Gallery")),
                ElevatedButton(onPressed: () => _processImage(ImageSource.camera), child: const Text("Camera")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
