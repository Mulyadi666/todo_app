import 'package:flutter/material.dart';
import '../widgets/task_form.dart';
import '../models/task.dart';

class AddTask extends StatelessWidget {
  final Function(Task) onSave;

  AddTask({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tugas'),
      ),
      body: TaskForm(
        onSave: (task) {
          onSave(task);
          Navigator.pop(
              context); // Kembali ke halaman sebelumnya setelah menyimpan
        },
      ),
    );
  }
}
