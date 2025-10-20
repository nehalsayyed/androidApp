import 'package:flutter/material.dart';

void main() => runApp(MindConnectApp());

class MindConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindConnect',
      home: SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Your Path')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Mentoring'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => MentoringForm()));
              },
            ),
            ElevatedButton(
              child: Text('Counseling'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CounselingForm()));
              },
            ),
          ],
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Your Name')),
            TextField(controller: problemController, decoration: InputDecoration(labelText: 'Overall Problem')),
            SizedBox(height: 20),
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedIssue,
              items: ['Relationship', 'Career', 'Other']
                  .map((issue) => DropdownMenuItem(value: issue, child: Text(issue)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedIssue = value!;
                });
              },
            ),
            SizedBox(height: 20),
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
