import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navigation/nav_bar.dart';
import 'models/task.dart';
import 'models/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Todo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoAppState(),
    );
  }
}

class TodoAppState extends StatefulWidget {
  @override
  _TodoAppStateState createState() => _TodoAppStateState();
}

class _TodoAppStateState extends State<TodoAppState> {
  List<Task> tasks = [];
  List<Note> notes = [];
  bool isDarkMode = false;

  void addTask(Task task) async {
    var docRef = await FirebaseFirestore.instance.collection('tasks').add({
      'description': task.description,
      'isCompleted': task.isCompleted,
    });
    setState(() {
      tasks.add(Task(
          id: docRef.id,
          description: task.description,
          isCompleted: task.isCompleted));
    });
  }

  void editTask(int index, Task updatedTask) async {
    try {
      var taskDoc =
          FirebaseFirestore.instance.collection('tasks').doc(updatedTask.id);
      await taskDoc.update({
        'description': updatedTask.description,
        'isCompleted': updatedTask.isCompleted,
      });

      setState(() {
        tasks[index] = updatedTask; // Update lokal
      });
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  void toggleTaskCompletion(String id) async {
    try {
      var taskDoc = FirebaseFirestore.instance
          .collection('tasks')
          .doc(id); // Menerima ID tugas
      DocumentSnapshot doc = await taskDoc.get();

      if (doc.exists) {
        bool currentStatus = doc['isCompleted'];
        await taskDoc.update({'isCompleted': !currentStatus});

        // Perbarui status tugas secara lokal
        setState(() {
          tasks = tasks.map((task) {
            if (task.id == id) {
              return Task(
                id: task.id,
                description: task.description,
                isCompleted: !currentStatus,
              );
            }
            return task;
          }).toList();
        });
      }
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  void addNote(Note note) async {
    var docRef = await FirebaseFirestore.instance.collection('notes').add({
      'title': note.title,
      'content': note.content,
    });
    setState(() {
      notes.add(Note(id: docRef.id, title: note.title, content: note.content));
    });
  }

  void editNote(int index, Note note) async {
    if (index < 0 || index >= notes.length) {
      print('Indeks tidak valid: $index');
      return;
    }

    var noteDoc =
        FirebaseFirestore.instance.collection('notes').doc(notes[index].id);

    try {
      await noteDoc.update({
        'title': note.title,
        'content': note.content,
      });
      setState(() {
        notes[index] = Note(
          id: notes[index].id, // Pastikan ID tetap sama
          title: note.title,
          content: note.content,
        );
      });
      print('Catatan berhasil diperbarui: ${note.title}');
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todoit.',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: NavBar(
        tasks: tasks,
        notes: notes,
        addTask: addTask,
        editTask: editTask,
        toggleTaskCompletion: toggleTaskCompletion,
        addNote: addNote,
        editNote: editNote,
        toggleDarkMode: toggleDarkMode,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
