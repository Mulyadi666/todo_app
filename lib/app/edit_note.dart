import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/note_form.dart';
import '../models/note.dart';
import 'package:share_plus/share_plus.dart';

class EditNote extends StatelessWidget {
  final Note note;
  final Function(Note) onSave;

  const EditNote({required this.note, required this.onSave, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share the note title and content
              Share.share('${note.title}\n\n${note.content}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Catatan'),
                  content: const Text(
                      'Apakah Anda yakin ingin menghapus catatan ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  var noteDoc = FirebaseFirestore.instance
                      .collection('notes')
                      .doc(note.id);
                  await noteDoc.delete();
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                  print('Catatan berhasil dihapus');
                } catch (e) {
                  print('Gagal menghapus catatan: $e');
                }
              }
            },
          ),
        ],
      ),
      body: NoteForm(
        note: note,
        onSave: (updatedNote) async {
          try {
            var noteDoc =
                FirebaseFirestore.instance.collection('notes').doc(note.id);
            await noteDoc.update({
              'title': updatedNote.title,
              'content': updatedNote.content,
            });
            Navigator.pop(context);
            print('Catatan berhasil diperbarui');
          } catch (e) {
            print('Gagal memperbarui catatan: $e');
          }
        },
      ),
    );
  }
}
