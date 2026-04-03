import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_subject_segmentation/google_mlkit_subject_segmentation.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart'; // For InputImage

void main() => runApp(const MaterialApp(home: SubjectDetectionPage()));

class SubjectDetectionPage extends StatefulWidget {
  const SubjectDetectionPage({super.key});

  @override
  State<SubjectDetectionPage> createState() => _SubjectDetectionPageState();
}

class _SubjectDetectionPageState extends State<SubjectDetectionPage> {
  File? _selectedImage;
  String _resultText = "Pick an image";
  int _subjectCount = 0;
  
  final ImagePicker _picker = ImagePicker();
  
  // 1. Setup Labeler and Subject Segmenter
  final ImageLabeler _imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));
  final SubjectSegmenter _segmenter = SubjectSegmenter(
    options: SubjectSegmenterOptions(
      enableMultipleSubjects: true, // This is the "No Selfie" advantage!
      enableConfidenceMask: true,
    ),
  );

  Future<void> _processImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
      _resultText = "Analyzing subjects...";
    });

    final inputImage = InputImage.fromFile(_selectedImage!);

    // 2. Run both models
    final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);
    final result = await _segmenter.processImage(inputImage);

    setState(() {
      _subjectCount = result.subjects.length;
      
      String text = "I see these labels:\n";
      for (var label in labels) {
        text += "• ${label.label} (${(label.confidence * 100).toStringAsFixed(0)}%)\n";
      }
      
      text += "\nFound $_subjectCount distinct subjects!";
      _resultText = text;
    });
  }

  @override
  void dispose() {
    _imageLabeler.close();
    _segmenter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subject AI")),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (_selectedImage != null)
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_selectedImage!, height: 350),
                ),
              )
            else
              const Icon(Icons.add_a_photo, size: 100, color: Colors.blueGrey),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_resultText, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _processImage(ImageSource.gallery), child: const Text("Gallery")),
                ElevatedButton(onPressed: () => _processImage(ImageSource.camera), child: const Text("Camera")),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
