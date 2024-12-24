import 'package:flutter/material.dart';
import '../widgets/note_form.dart';
import '../models/note.dart';

class AddNote extends StatelessWidget {
  final Function(Note) onSave;

  AddNote({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: NoteForm(
        onSave: (note) {
          onSave(note);
          Navigator.pop(
              context); // Kembali ke halaman sebelumnya setelah menyimpan
        },
      ),
    );
  }
}
