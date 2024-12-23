import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_options.dart';
import 'task_page.dart';
import 'task_detail.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todoit.',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final arguments = settings.arguments as Map<String, dynamic>;
          final task = arguments['task'];
          final onEdit = arguments['onEdit'];
          return MaterialPageRoute(
            builder: (context) => TaskDetails(
              task: task,
              onEdit: onEdit,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TaskPage(),
    const Center(child: Text("Halaman Profil")),
    const Center(child: Text("Halaman Pengaturan")),
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
        title: const Text(
          "Todoit.",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Aksi saat memilih dropdown item
            },
            itemBuilder: (BuildContext context) {
              return {'Profil', 'Pengaturan'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Utama',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Halaman Tugas'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            ListTile(
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Catatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tugas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
