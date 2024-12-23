import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'task_detail.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Map<String, dynamic>> tasks = [];
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _addTask(String task) {
    setState(() {
      tasks.add({'task': task, 'date': DateTime.now().toIso8601String()});
    });
    _saveTasks();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Tugas '$task' ditambahkan!")),
    );
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedTasks = tasks.map((task) => jsonEncode(task)).toList();
    prefs.setStringList('tasks', encodedTasks);
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedTasks =
        prefs.getStringList('tasks'); // Ambil List<String>
    setState(() {
      tasks = encodedTasks != null
          ? encodedTasks
              .map((task) => jsonDecode(task) as Map<String, dynamic>)
              .toList() // Lakukan casting
          : [];
    });
  }

  void _editTask(int index, String updatedTask, DateTime updatedDate) {
    setState(() {
      tasks[index]['task'] = updatedTask;
      tasks[index]['date'] = updatedDate.toIso8601String();
    });
    _saveTasks(); // Simpan perubahan ke storage
  }

  void _showAddTaskDialog() {
    String newTask = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah Tugas Baru"),
          content: TextField(
            onChanged: (value) {
              newTask = value;
            },
            decoration: const InputDecoration(hintText: "Nama Tugas"),
          ),
          actions: [
            TextButton(
              child: const Text("Tambah"),
              onPressed: () {
                if (newTask.isNotEmpty) {
                  _addTask(newTask);
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hapus Tugas"),
          content: const Text("Apakah Anda yakin ingin menghapus tugas ini?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Hapus"),
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                  _saveTasks();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tugas dihapus")),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Tugas"),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: _isGridView ? _buildGridView() : _buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(tasks[index]['task']),
          subtitle: Text(
            tasks[index]['date'].toString().split('T').first,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetails(
                  task: tasks[index]['task'],
                  onEdit: (updatedTask, updatedDate) {
                    _editTask(index, updatedTask, updatedDate);
                  },
                ),
              ),
            );
          },
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDeleteTask(index),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetails(
                  task: tasks[index]['task'],
                  onEdit: (updatedTask, updatedDate) {
                    _editTask(index, updatedTask, updatedDate);
                  },
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: GridTile(
              header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDeleteTask(index),
                  ),
                ),
              ),
              footer: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tasks[index]['date'].toString().split('T').first,
                  textAlign: TextAlign.center,
                ),
              ),
              child: Center(
                child: Text(
                  tasks[index]['task'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
