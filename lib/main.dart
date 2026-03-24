import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const ActionIconThemeExampleApp());
}

class ActionIconThemeExampleApp extends StatelessWidget {
  const ActionIconThemeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(title: 'Memory Monitor & Toast Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _memUsage = "Calculating...";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update memory usage every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateMemoryUsage();
    });
  }

  void _updateMemoryUsage() {
    // ProcessInfo provides Resident Set Size (RSS) in bytes
    final bytes = ProcessInfo.currentRss;
    final mb = bytes / (1024 * 1024);
    
    if (mounted) {
      setState(() {
        _memUsage = "${mb.toStringAsFixed(2)} MB";
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Custom Toast Function
  void _showCustomToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.yellow),
            const SizedBox(width: 12),
            Text('Action Triggered! Current Mem: $_memUsage'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blueGrey[900],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              label: Text(_memUsage, style: const TextStyle(fontSize: 12)),
              avatar: const Icon(Icons.memory, size: 16),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Real-time Memory Usage: $_memUsage", 
              style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _showCustomToast(context),
              icon: const Icon(Icons.notifications_active),
              label: const Text('Show Custom Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
