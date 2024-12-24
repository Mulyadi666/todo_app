import 'package:flutter/material.dart';
import 'package:todo_app/models/note.dart';
import '../widgets/note_form.dart';

class AddNote extends StatelessWidget {
  final Function(Note) onSave;

  AddNote({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: NoteForm(
        onSave: onSave,
      ),
    );
  }
}
