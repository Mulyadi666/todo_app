import 'package:flutter/material.dart';
import 'add_note.dart';
import 'edit_note.dart';
import '../models/note.dart';

class NotePage extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) addNote;
  final Function(int, Note) editNote;

  NotePage(
      {required this.notes, required this.addNote, required this.editNote});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catatan'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            subtitle: Text(notes[index].content),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNote(
                    note: notes[index],
                    onSave: (note) => editNote(index, note),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(
                onSave: addNote,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
