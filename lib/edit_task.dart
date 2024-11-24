import 'package:flutter/material.dart';

class EditTaskPage extends StatefulWidget {
  final String task;
  final DateTime date;

  const EditTaskPage({super.key, required this.task, required this.date});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _taskController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task);
    _selectedDate = widget.date;
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {
    Navigator.pop(context, {
      'task': _taskController.text,
      'date': _selectedDate,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Tugas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTask, // Simpan perubahan
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: "Edit Tugas"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tanggal: ${_selectedDate.toLocal()}".split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text("Pilih Tanggal"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
