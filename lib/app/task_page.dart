import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/task_form.dart';
import 'edit_task.dart';
import '../models/task.dart';

class TaskPage extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) addTask;
  final Function(int, Task) editTask;
  final Function(String) toggleTaskCompletion; // Tipe String untuk ID
  final Function(String) deleteTask; // Menggunakan ID tugas
  TaskPage({
    required this.tasks,
    required this.addTask,
    required this.editTask,
    required this.toggleTaskCompletion,
    required this.deleteTask, // Menggunakan ID untuk delete
  });

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> selectedTasks = []; // Menyimpan task yang dipilih untuk dihapus

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Tugas'),
          content: TaskForm(
            onSave: (task) {
              widget.addTask(task);
              Navigator.pop(context); // Menutup dialog setelah menambah task
            },
          ),
        );
      },
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedTasks.contains(widget.tasks[index])) {
        selectedTasks.remove(widget.tasks[index]);
      } else {
        selectedTasks.add(widget.tasks[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas'),
        actions: [
          if (selectedTasks.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Menghapus task yang dipilih berdasarkan ID
                selectedTasks.forEach((task) {
                  widget.deleteTask(task.id);
                  // Menghapus berdasarkan ID
                });
                setState(() {
                  selectedTasks.clear(); // Clear the selection after delete
                });
              },
            ),
        ],
      ),
      body: StreamBuilder(
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
                onLongPress: () {
                  _toggleSelection(index); // Tahan untuk memilih
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: tasks[index].isCompleted,
                      onChanged: (bool? value) {
                        // Toggle task completion status by task ID
                        widget.toggleTaskCompletion(
                            tasks[index].id); // Menggunakan ID
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
