import 'package:flutter/material.dart';
import 'navigation/nav_bar.dart';
import 'models/task.dart';
import 'models/note.dart';

void main() {
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

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void editTask(int index, Task task) {
    setState(() {
      tasks[index] = task;
    });
  }

  void addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  void editNote(int index, Note note) {
    setState(() {
      notes[index] = note;
    });
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
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
