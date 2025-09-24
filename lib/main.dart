

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(GalleryApp());
}

class GalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GalleryHome(),
    );
  }
}

class GalleryHome extends StatefulWidget {
  @override
  _GalleryHomeState createState() => _GalleryHomeState();
}

class _GalleryHomeState extends State<GalleryHome> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  Future<void> _pickImage(ImageSource source) async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Widget _buildImageTile(File image) {
    return OpenContainer(
      closedElevation: 0,
      transitionDuration: Duration(milliseconds: 500),
      closedBuilder: (context, action) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(image, fit: BoxFit.cover),
      ),
      openBuilder: (context, action) => Scaffold(
        appBar: AppBar(title: Text("View Image")),
        body: Center(
          child: PhotoView(imageProvider: FileImage(image)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Gallery"),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
      body: _images.isEmpty
          ? Center(child: Text("No images yet. Tap camera or gallery."))
          : GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => _buildImageTile(_images[index]),
            ),
    );
  }
}











/*import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(NehalGame());

class NehalGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nehal's Game",
      theme: ThemeData.dark(),
      home: FlappyBirdGame(),
    );
  }
}

class FlappyBirdGame extends StatefulWidget {
  @override
  State<FlappyBirdGame> createState() => _FlappyBirdGameState();
}

class _FlappyBirdGameState extends State<FlappyBirdGame> {
  // Game physics constants
  static const double gravity = 0.4;
  static const double jumpVelocity = -8;
  static const double birdSize = 40;
  static const double pipeWidth = 60;
  static const double gapHeight = 200;
  static const double pipeSpeed = 3;

  double birdY = 300;
  double velocity = 0;
  double pipeX = 400;
  double gapY = 250;
  bool isGameRunning = false;
  int score = 0;
  Timer? gameLoop;

  void startGame() {
    isGameRunning = true;
    birdY = 300;
    velocity = 0;
    pipeX = MediaQuery.of(context).size.width;
    gapY = Random().nextInt(250) + 150;
    score = 0;

    gameLoop?.cancel();
    gameLoop = Timer.periodic(Duration(milliseconds: 16), (_) {
      setState(() {
        velocity += gravity;
        birdY += velocity;
        pipeX -= pipeSpeed;

        if (pipeX < -pipeWidth) {
          pipeX = MediaQuery.of(context).size.width;
          gapY = Random().nextInt(250) + 150;
          score++; // Increase score when pipe resets
        }

        if (checkCollision()) {
          gameLoop?.cancel();
          isGameRunning = false;
        }
      });
    });
  }

  void jump() {
    if (!isGameRunning) {
      startGame();
    }
    setState(() {
      velocity = jumpVelocity;
    });
  }

  bool checkCollision() {
    final screenHeight = MediaQuery.of(context).size.height;

    // Top and bottom screen bounds
    if (birdY < 0 || birdY + birdSize > screenHeight) return true;

    // Pipe collision
    if (pipeX < 100 && pipeX + pipeWidth > 60) {
      if (birdY < gapY || birdY + birdSize > gapY + gapHeight) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: jump,
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Stack(
          children: [
            // Bird
            Positioned(
              left: 60,
              top: birdY,
              child: Container(
                width: birdSize,
                height: birdSize,
                decoration: BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
              ),
            ),

            // Top Pipe
            Positioned(
              left: pipeX,
              top: 0,
              child: Container(
                width: pipeWidth,
                height: gapY,
                color: Colors.green,
              ),
            ),

            // Bottom Pipe
            Positioned(
              left: pipeX,
              top: gapY + gapHeight,
              child: Container(
                width: pipeWidth,
                height: MediaQuery.of(context).size.height - gapY - gapHeight,
                color: Colors.green,
              ),
            ),

            // Score Display
            Positioned(
              top: 40,
              left: 20,
              child: Text(
                'Score: $score',
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            // Game Title
            Positioned(
              top: 40,
              right: 20,
              child: Text(
                "Nehal's Game",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

            // About Button
            Positioned(
              bottom: 40,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
                child: Text('About'),
              ),
            ),

            // Start Message
            if (!isGameRunning)
              Center(
                child: Text(
                  'TAP TO START',
                  style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text("About Nehal's Game"),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Developer',
              style: TextStyle(fontSize: 22, color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              'Nehal Sayyed',
              style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Text(
              'Game Title',
              style: TextStyle(fontSize: 22, color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              "Nehal's Game",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 24),
            Text(
              'Description',
              style: TextStyle(fontSize: 22, color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              'A simple Flappy Bird-style game built entirely with Flutter widgets. No images, no assets — just pure code and creativity!',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back to Game'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

