import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/task_form.dart';
import '../models/task.dart';
import 'package:share_plus/share_plus.dart';

class EditTask extends StatelessWidget {
  final Task task;
  final Function(Task) onSave;

  EditTask({required this.task, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tugas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share the note title and content
              Share.share('${task.description}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Tugas'),
                  content: const Text(
                      'Apakah Anda yakin ingin menghapus tugas ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  var taskDoc = FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(task.id);
                  await taskDoc.delete();
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                  print('Tugas berhasil dihapus');
                } catch (e) {
                  print('Gagal menghapus tugas: $e');
                }
              }
            },
          ),
        ],
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
