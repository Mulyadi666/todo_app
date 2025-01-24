import 'package:flutter/material.dart';
import 'package:todo_app/app/login.dart';
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
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: widget.toggleDarkMode as VoidCallback,
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: 16.0), // Menambahkan padding 16 piksel di kanan
            child: TextButton(
              onPressed: () {
                // Navigasi ke halaman Login ketika tombol ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()), // Pindah ke LoginPage
                );
              },
              child: Text(
                'Login',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // Jika dark mode, tombol warna putih
                      : Colors.black, // Jika light mode, tombol warna hitam
                  fontSize: 16.0,
                ),
              ),
            ),
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
