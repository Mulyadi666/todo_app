import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/task_form.dart';
import 'edit_task.dart';
import '../models/task.dart';

class TaskPage extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) addTask;
  final Function(int, Task) editTask;
  final Function(int) toggleTaskCompletion;

  TaskPage({
    required this.tasks,
    required this.addTask,
    required this.editTask,
    required this.toggleTaskCompletion,
  });

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Tugas'),
          content: TaskForm(
            onSave: (task) {
              addTask(task);
            },
          ),
        );
      },
    ).then((_) {
      // Focus on the text field when the dialog is shown
      Future.delayed(Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(FocusNode());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas'),
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
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  tasks[index].description,
                  style: TextStyle(
                    decoration: tasks[index].isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: Checkbox(
                  value: tasks[index].isCompleted,
                  onChanged: (bool? value) {
                    toggleTaskCompletion(index);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTask(
                        task: tasks[index],
                        onSave: (task) => editTask(index, task),
                      ),
                    ),
                  );
                },
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
