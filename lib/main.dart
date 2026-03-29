import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'main.g.dart'; // The code generator will create this file

@collection
class Todo {
  Id id = Isar.autoIncrement; // Local primary key

  @Index(type: IndexType.value)
  late String title;

  bool isDone = false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Get the directory where the APK can store data
  final dir = await getApplicationDocumentsDirectory();
  
  // 2. Open the Isar instance
  final isar = await Isar.open(
    [TodoSchema],
    directory: dir.path,
  );

  runApp(MaterialApp(home: TodoScreen(isar: isar)));
}

class TodoScreen extends StatefulWidget {
  final Isar isar;
  const TodoScreen({super.key, required this.isar});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshTodos();
  }

  // Read: Fetch all todos from local DB
  Future<void> _refreshTodos() async {
    final allTodos = await widget.isar.todos.where().findAll();
    setState(() => todos = allTodos);
  }

  // Create: Add a new todo
  Future<void> _addTodo() async {
    final newTodo = Todo()..title = controller.text;
    await widget.isar.writeTxn(() => widget.isar.todos.put(newTodo));
    controller.clear();
    _refreshTodos();
  }

  // Update: Toggle completion
  Future<void> _toggleTodo(Todo todo) async {
    todo.isDone = !todo.isDone;
    await widget.isar.writeTxn(() => widget.isar.todos.put(todo));
    _refreshTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isar Local Todo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter task...',
                suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: _addTodo),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(todos[i].title),
                trailing: Checkbox(
                  value: todos[i].isDone,
                  onChanged: (_) => _toggleTodo(todos[i]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
