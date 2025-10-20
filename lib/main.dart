import 'package:flutter/material.dart';

void main() => runApp(MindConnectApp());

class MindConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindConnect',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.green.shade50,
        ),
      ),
      home: SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gebby MindConnect')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.psychology, size: 80, color: Colors.green),
              SizedBox(height: 20),
              Text(
                'Welcome to MindConnect',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]),
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
              style: TextStyle(fontSize: 18, color: Colors.green[700]),
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
              style: TextStyle(fontSize: 18, color: Colors.green[700]),
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
