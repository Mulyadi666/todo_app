import 'package:flutter/material.dart';
import 'package:todo_app/models/note.dart';
import '../widgets/note_form.dart';

class EditNote extends StatelessWidget {
  final Note note;
  final Function(Note) onSave;

  EditNote({
    Key? key,
    required this.note,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: NoteForm(
        note: note,
        onSave: onSave,
      ),
    );
  }
}
