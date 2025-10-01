import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BannerDemo(),
    );
  }
}

class BannerDemo extends StatelessWidget {
  void _showBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text('This is a Material Banner'),
        leading: Icon(Icons.info),
        backgroundColor: Colors.yellow[200],
        actions: [
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: Text('DISMISS'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MaterialBanner Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showBanner(context),
          child: Text('Show Banner'),
        ),
      ),
    );
  }
}
