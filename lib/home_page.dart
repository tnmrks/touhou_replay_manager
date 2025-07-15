import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Touhou Replay Manager'),
        backgroundColor: Colors.indigo, // Anda bisa ganti warnanya
      ),
      body: const Center(
        child: Text('Daftar Replay akan muncul di sini.'),
      ),
    );
  }
}