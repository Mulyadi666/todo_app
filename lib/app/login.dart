import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  // Validator untuk tombol login, tombol hanya aktif jika email dan password valid
  Stream<bool> get isFormValid =>
      Rx.combineLatest2(_emailController.stream, _passwordController.stream,
          (String email, String password) {
        return email.isNotEmpty && password.isNotEmpty;
      });

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    super.dispose();
  }

  // Fungsi untuk login
  void _login() {
    final email = _emailController.value;
    final password = _passwordController.value;

    if (email.isNotEmpty && password.isNotEmpty) {
      // Implementasikan logika login Anda di sini
      print('Login dengan email: $email, password: $password');
    } else {
      print('Input tidak valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Input Field
            TextField(
              onChanged: _emailController.add,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Password Input Field
            TextField(
              onChanged: _passwordController.add,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),

            // Tombol Login
            StreamBuilder<bool>(
              stream: isFormValid,
              builder: (context, snapshot) {
                return ElevatedButton(
                  onPressed: snapshot.hasData && snapshot.data == true
                      ? _login
                      : null, // Tombol hanya aktif jika form valid
                  child: Text('Login'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
