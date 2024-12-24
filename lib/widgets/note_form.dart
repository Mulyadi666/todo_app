import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteForm extends StatefulWidget {
  final Function(Note) onSave;
  final Note? note;

  NoteForm({required this.onSave, this.note});

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title;
      _content = widget.note!.content;
    } else {
      _title = '';
      _content = '';
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
              initialValue: _title,
              decoration: InputDecoration(labelText: 'Judul Catatan'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
              onSaved: (value) {
                _title = value!;
              },
            ),
            TextFormField(
              initialValue: _content,
              decoration: InputDecoration(labelText: 'Isi Catatan'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Isi tidak boleh kosong';
                }
                return null;
              },
              onSaved: (value) {
                _content = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  widget.onSave(Note(
                    id: widget.note?.id ?? '',
                    title: _title,
                    content: _content,
                  ));
                  Navigator.pop(context);
                }
              },
              child: Text('Simpan Catatan'),
            ),
          ],
        ),
      ),
    );
  }
}
