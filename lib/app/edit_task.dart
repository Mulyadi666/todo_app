import 'package:flutter/material.dart';
import '../widgets/task_form.dart';
import '../models/task.dart';

class EditTask extends StatelessWidget {
  final Task task;
  final Function(Task) onSave;

  EditTask({required this.task, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tugas'),
      ),
      body: TaskForm(
        onSave: (updatedTask) {
          onSave(updatedTask);
          Navigator.pop(
              context); // Kembali ke halaman sebelumnya setelah menyimpan
        },
        task: task,
      ),
    );
  }
}
