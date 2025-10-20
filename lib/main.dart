import 'package:flutter/material.dart';
                                                  void main() => runApp(PeerInMotionApp());
                                                  class PeerInMotionApp extends StatelessWidget {
  @override                                         Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peer in Motion',
      theme: ThemeData(                                   primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.pink.shade50,
        ),
      ),
      home: OpeningScreen(),
    );
  }
}

class OpeningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Peer in Motion')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, size: 80, color: Colors.pinkAccent),
              SizedBox(height: 30),
              Text(
                'Hello! Hi, I’m your sister �\nYou can think of me as someone who truly listens —\na sister you can talk to about anything, anytime.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink[700],
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                icon: Icon(Icons.arrow_forward),
                label: Text('Continue'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SelectionScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Peer in Motion')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.psychology, size: 80, color: Colors.pinkAccent),
              SizedBox(height: 20),
              Text(
                'Welcome to Peer in Motion',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                icon: Icon(Icons.school),
                label: Text('Mentoring'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MentoringForm()));
                },
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.favorite),
                label: Text('Counseling'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CounselingForm()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MentoringForm extends StatelessWidget {
  final nameController = TextEditingController();
  final problemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mentoring Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Let us know how we can help you grow.',
              style: TextStyle(fontSize: 18, color: Colors.pink[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Your Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: problemController,
              decoration: InputDecoration(labelText: 'Describe Your Challenge'),
              maxLines: 4,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Request Mentor'),
              onPressed: () {
                // Logic to connect with mentor
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CounselingForm extends StatefulWidget {
  @override
  _CounselingFormState createState() => _CounselingFormState();
}

class _CounselingFormState extends State<CounselingForm> {
  String selectedIssue = 'Relationship';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counseling Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Choose the issue you need help with:',
              style: TextStyle(fontSize: 18, color: Colors.pink[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: selectedIssue,
              decoration: InputDecoration(labelText: 'Issue Type'),
              items: ['Relationship', 'Career', 'Other']
                  .map((issue) => DropdownMenuItem(value: issue, child: Text(issue)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedIssue = value!;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Request Counselor'),
              onPressed: () {
                // Logic to connect with counselor
              },
            ),
          ],
        ),
      ),
    );
  }
}
