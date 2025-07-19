import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Login Pengguna')),
    body: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Kolom untuk input Email
          TextField(
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16), // Memberi jarak

          // Kolom untuk input Password
          TextField(
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true, // Menyembunyikan teks password
          ),
          const SizedBox(height: 24), // Memberi jarak

          // Tombol untuk Login
          ElevatedButton(
            onPressed: () {
              // Fungsi login akan ditambahkan di sesi berikutnya
            },
            child: const Text('Login'),
          ),

          // Tombol untuk pindah ke halaman registrasi
          TextButton(
            onPressed: () {
              // Fungsi navigasi ke halaman registrasi akan ditambahkan nanti
            },
            child: const Text('Belum punya akun? Daftar di sini'),
          )
        ],
      ),
    ),
  );
}
}
