import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_subject_segmentation/google_mlkit_subject_segmentation.dart';

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
  
  final ImageLabeler _imageLabeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.5),
  );

  // FIXED: Removed the .all and used the class constructor
  final SubjectSegmenter _segmenter = SubjectSegmenter(
    options: SubjectSegmenterOptions(
      enableForegroundConfidenceMask: true,
      enableForegroundBitmap: true,
      enableMultipleSubjects: SubjectResultOptions(), 
    ),
  );

  Future<void> _processImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
      _resultText = "Analyzing...";
    });

    final inputImage = InputImage.fromFile(_selectedImage!);

    try {
      final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);
      final result = await _segmenter.processImage(inputImage);

      setState(() {
        _subjectCount = result.subjects.length;
        
        String text = "Labels found:\n";
        for (var label in labels) {
          text += "• ${label.label} (${(label.confidence * 100).toStringAsFixed(0)}%)\n";
        }
        
        text += "\nSubjects segmented: $_subjectCount";
        _resultText = text;
      });
    } catch (e) {
      setState(() {
        _resultText = "Error: $e";
      });
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 300)
            else
              const Icon(Icons.image, size: 100, color: Colors.grey),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(_resultText, textAlign: TextAlign.center),
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
