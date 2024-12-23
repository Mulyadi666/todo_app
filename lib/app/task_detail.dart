import 'package:flutter/material.dart';
import 'edit_task.dart';

class TaskDetails extends StatefulWidget {
  final String task; // Data tugas yang dikirim dari halaman sebelumnya
  final Function(String updatedTask, DateTime updatedDate)? onEdit;

  const TaskDetails({super.key, required this.task, this.onEdit});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late String taskText;
  late DateTime taskDate;

  @override
  void initState() {
    super.initState();
    taskText = widget.task;
    taskDate = DateTime.now(); // Default tanggal
  }

  void _editTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskPage(
          task: taskText,
          date: taskDate,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        taskText = result['task'];
        taskDate = result['date'];
      });

      // Callback untuk mengirim data ke halaman sebelumnya (jika ada)
      if (widget.onEdit != null) {
        widget.onEdit!(taskText, taskDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Tugas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editTask, // Panggil fungsi edit
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tugas:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              taskText,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Tanggal:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${taskDate.toLocal()}".split(' ')[0],
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
