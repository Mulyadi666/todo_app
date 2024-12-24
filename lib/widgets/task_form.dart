import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskForm extends StatefulWidget {
  final Function(Task) onSave;
  final Task? task;

  TaskForm({required this.onSave, this.task});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _description;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _description = widget.task!.description;
    } else {
      _description = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: _description,
              decoration: InputDecoration(labelText: 'Deskripsi Tugas'),
              onSaved: (value) {
                _description = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  widget.onSave(Task(description: _description));
                  Navigator.pop(context);
                }
              },
              child: Text('Simpan Tugas'),
            ),
          ],
        ),
      ),
    );
  }
}
