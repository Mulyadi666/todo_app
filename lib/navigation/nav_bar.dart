import 'package:flutter/material.dart';
import '../app/task_page.dart';
import '../app/note_page.dart';
import '../models/task.dart';
import '../models/note.dart';

class NavBar extends StatefulWidget {
  final List<Task> tasks;
  final List<Note> notes;
  final Function(Task) addTask;
  final Function(int, Task) editTask;
  final Function(String) toggleTaskCompletion; // Mengubah ke String
  final Function(Note) addNote;
  final Function(int, Note) editNote;
  final Function toggleDarkMode;
  final bool isDarkMode;

  NavBar({
    required this.tasks,
    required this.notes,
    required this.addTask,
    required this.editTask,
    required this.toggleTaskCompletion, // Pastikan tipe ini sesuai
    required this.addNote,
    required this.editNote,
    required this.toggleDarkMode,
    required this.isDarkMode,
  });

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
        TaskPage(
          tasks: widget.tasks,
          addTask: widget.addTask,
          editTask: widget.editTask,
          toggleTaskCompletion: widget.toggleTaskCompletion,
          deleteTask: (taskId) {
            // Implement the delete task functionality here
          },
        ),
        NotePage(
          notes: widget.notes,
          addNote: widget.addNote,
          editNote: widget.editNote,
        ),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Aplikasi Todo'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: widget.toggleDarkMode as VoidCallback,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Catatan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
