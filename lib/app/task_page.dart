import 'package:flutter/material.dart';
import 'add_task.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas'),
      ),
      body: ListView.builder(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTask(
                onSave: addTask,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
