import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('todoBox'); // Open a "drawer" to put data in
  runApp(const MaterialApp(home: SimpleTodo()));
}

class SimpleTodo extends StatefulWidget {
  const SimpleTodo({super.key});

  @override
  State<SimpleTodo> createState() => _SimpleTodoState();
}

class _SimpleTodoState extends State<SimpleTodo> {
  final myBox = Hive.box('todoBox');
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive is way easier')),
      body: Column(
        children: [
          TextField(controller: controller),
          ElevatedButton(
            onPressed: () {
              // Write: Just like a Map!
              myBox.add({'task': controller.text, 'done': false});
              setState(() {}); // Refresh UI
            },
            child: const Text('Add'),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: myBox.listenable(),
              builder: (context, Box box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final item = box.getAt(index);
                    return ListTile(title: Text(item['task']));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
