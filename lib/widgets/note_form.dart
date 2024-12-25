import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteForm extends StatefulWidget {
  final Function(Note) onSave;
  final Note? note;

  const NoteForm({required this.onSave, this.note, Key? key}) : super(key: key);

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul Catatan'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Judul tidak boleh kosong'
                  : null,
            ),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Isi Catatan'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Isi tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSave(Note(
                    id: widget.note?.id ??
                        '', // ID tetap kosong untuk catatan baru
                    title: _titleController.text,
                    content: _contentController.text,
                  ));
                }
              },
              child: const Text('Simpan Catatan'),
            ),
          ],
        ),
      ),
    );
  }
}
