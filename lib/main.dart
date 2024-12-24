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

  void editTask(int index, Task task) async {
    var taskDoc =
        FirebaseFirestore.instance.collection('tasks').doc(tasks[index].id);
    await taskDoc.update({
      'description': task.description,
      'isCompleted': task.isCompleted,
    });
    setState(() {
      tasks[index] = task;
    });
  }

  void toggleTaskCompletion(int index) async {
    var taskDoc =
        FirebaseFirestore.instance.collection('tasks').doc(tasks[index].id);
    await taskDoc.update({
      'isCompleted': !tasks[index].isCompleted,
    });
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
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
    var noteDoc =
        FirebaseFirestore.instance.collection('notes').doc(notes[index].id);
    await noteDoc.update({
      'title': note.title,
      'content': note.content,
    });
    setState(() {
      notes[index] = note;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavBar(
      tasks: tasks,
      notes: notes,
      addTask: addTask,
      editTask: editTask,
      toggleTaskCompletion: toggleTaskCompletion,
      addNote: addNote,
      editNote: editNote,
    );
  }
}
