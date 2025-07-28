import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:touhou_replay_manager/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Deklarasi controller untuk mengambil input teks
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 2. Fungsi untuk proses login
  Future<void> signIn() async {
    try {
      // Melakukan proses login dengan Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigasi setelah login berhasil akan ditangani secara otomatis oleh AuthWrapper
    } on FirebaseAuthException catch (e) {
      // Jika terjadi error, cek apakah halaman masih ada sebelum menampilkan SnackBar
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Terjadi error yang tidak diketahui.")),
      );
    }
  }

  // Membersihkan controller saat widget tidak lagi digunakan untuk mencegah kebocoran memori
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Pengguna')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kolom input Email
            TextField(
              controller: _emailController, // Menghubungkan controller
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Kolom input Password
            TextField(
              controller: _passwordController, // Menghubungkan controller
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // Tombol Login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signIn, // Memanggil fungsi signIn saat ditekan
                child: const Text('Login'),
              ),
            ),

            // Tombol untuk pindah ke halaman registrasi
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Belum punya akun? Daftar di sini'),
            )
          ],
        ),
      ),
    );
  }
}