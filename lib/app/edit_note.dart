import 'package:flutter/material.dart';
import '../widgets/note_form.dart';
import '../models/note.dart';

class EditNote extends StatelessWidget {
  final Note note;
  final Function(Note) onSave;

  EditNote({required this.note, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Catatan'),
      ),
      body: NoteForm(
        note: note, // Kirim catatan yang akan diedit
        onSave: (updatedNote) {
          onSave(updatedNote);
          Navigator.pop(
              context); // Kembali ke halaman sebelumnya setelah menyimpan
        },
      ),
    );
  }
}
