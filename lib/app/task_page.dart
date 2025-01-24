import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../widgets/task_form.dart';
import 'edit_task.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class TaskPage extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) addTask;
  final Function(int, Task) editTask;
  final Function(String)
      toggleTaskCompletion; // Fungsi untuk toggle status tugas
  final Function(String)
      deleteTask; // Fungsi untuk menghapus tugas berdasarkan ID

  TaskPage({
    required this.tasks,
    required this.addTask,
    required this.editTask,
    required this.toggleTaskCompletion,
    required this.deleteTask,
  });

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Tugas'),
          content: TaskForm(
            onSave: (task) {
              widget.addTask(task);
              Navigator.pop(context); // Menutup dialog setelah menambah tugas
            },
          ),
        );
      },
    );
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
      print('Tugas berhasil dihapus');
    } catch (e) {
      print('Gagal menghapus tugas: $e');
    }
  }

  Future<void> _handleRefresh() async {
    try {
      // Ambil data terbaru dari Firestore
      final querySnapshot =
          await FirebaseFirestore.instance.collection('tasks').get();

      // Buat daftar tugas dari data yang diambil
      final tasks = querySnapshot.docs.map((doc) {
        return Task(
          id: doc.id,
          description: doc['description'],
          isCompleted: doc['isCompleted'],
        );
      }).toList();

      // Perbarui data lokal (jika menggunakan state management, simpan di provider atau state)
      setState(() {
        // Di sini Anda dapat menyimpan tasks ke dalam state lokal
        // Jika menggunakan state management, ubah logikanya sesuai kebutuhan
        widget.tasks.clear();
        widget.tasks.addAll(tasks);
      });
    } catch (e) {
      print('Gagal menyegarkan data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyegarkan data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas'),
      ),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false, // Menghilangkan transisi opasitas
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var tasks = snapshot.data!.docs.map((doc) {
              return Task(
                id: doc.id,
                description: doc['description'],
                isCompleted: doc['isCompleted'],
              );
            }).toList();

            if (tasks.isEmpty) {
              return Center(child: Text('Tidak ada tugas'));
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Hapus Tugas'),
                        content: Text(
                            'Apakah Anda yakin ingin menghapus tugas ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await _deleteTask(tasks[index].id);
                    }
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: tasks[index].isCompleted,
                        onChanged: (bool? value) {
                          widget.toggleTaskCompletion(tasks[index].id);
                        },
                      ),
                      title: Text(
                        tasks[index].description,
                        style: TextStyle(
                          decoration: tasks[index].isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTask(
                              task: tasks[index],
                              onSave: (task) => widget.editTask(index, task),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
