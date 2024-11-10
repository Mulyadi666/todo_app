import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Digunakan untuk encoding dan decoding data
import 'task_detail.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<String> tasks = []; // Daftar tugas
  bool _isGridView = false; // Variabel untuk mengatur tampilan Grid atau List
  @override
  void initState() {
    super.initState();
    _loadTasks(); // Muat tugas dari shared_preferences saat aplikasi dimulai
  }

  // Fungsi untuk menambah tugas baru dan menyimpannya
  void _addTask(String task) {
    setState(() {
      tasks.add(task);
    });
    _saveTasks(); // Simpan tugas ke shared_preferences
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Tugas '$task' ditambahkan!")),
    );
  }

  // Fungsi untuk menyimpan tugas ke shared_preferences
  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', tasks); // Simpan sebagai list of string
  }

  // Fungsi untuk memuat tugas dari shared_preferences
  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = prefs.getStringList('tasks') ??
          []; // Muat list atau gunakan list kosong jika null
    });
  }

  // Fungsi untuk menampilkan dialog tambah tugas
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
                _addTask(newTask);
                Navigator.of(context).pop();
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

  // Fungsi untuk menghapus tugas dengan konfirmasi
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
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Tugas dihapus")),
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
                _isGridView = !_isGridView; // Toggle antara List dan Grid
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

  // Fungsi untuk menampilkan daftar tugas dalam tampilan List
  Widget _buildListView() {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(tasks[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetails(task: tasks[index]),
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

  // Fungsi untuk menampilkan daftar tugas dalam tampilan Grid
  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Jumlah kolom di grid
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
                builder: (context) => TaskDetails(task: tasks[index]),
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
              child: Center(
                child: Text(
                  tasks[index],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
