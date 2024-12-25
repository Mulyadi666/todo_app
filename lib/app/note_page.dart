import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_note.dart';
import 'edit_note.dart';
import '../models/note.dart';

class NotePage extends StatefulWidget {
  final List<Note> notes;
  final Function(Note) addNote;
  final Function(int, Note) editNote;

  NotePage({
    required this.notes,
    required this.addNote,
    required this.editNote,
  });

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool isGridView = false;

  void toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  Future<void> _deleteNote(String noteId) async {
    try {
      await FirebaseFirestore.instance.collection('notes').doc(noteId).delete();
      print('Catatan berhasil dihapus');
    } catch (e) {
      print('Gagal menghapus catatan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catatan'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: toggleView,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('notes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var notes = snapshot.data!.docs.map((doc) {
            return Note(
              id: doc.id,
              title: doc['title'],
              content: doc['content'],
            );
          }).toList();
          return isGridView ? buildGridView(notes) : buildListView(notes);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(
                onSave: widget.addNote,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildListView(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Hapus Catatan'),
                content: Text('Apakah Anda yakin ingin menghapus catatan ini?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Hapus'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              await _deleteNote(notes[index].id);
            }
          },
          child: ListTile(
            title: Text(notes[index].title),
            subtitle: Text(notes[index].content),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNote(
                    note: notes[index],
                    onSave: (note) => widget.editNote(index, note),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildGridView(List<Note> notes) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: notes.map((note) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNote(
                    note: note,
                    onSave: (updatedNote) =>
                        widget.editNote(notes.indexOf(note), updatedNote),
                  ),
                ),
              );
            },
            onLongPress: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Hapus Catatan'),
                  content:
                      Text('Apakah Anda yakin ingin menghapus catatan ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Hapus'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await _deleteNote(note.id);
              }
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : const Color.fromARGB(255, 255, 233, 254),
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: BoxConstraints(
                minWidth: 100,
                maxWidth: MediaQuery.of(context).size.width / 2 - 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
