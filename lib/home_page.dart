import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_replay_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Touhou Replay Manager'),
        backgroundColor: Colors.indigo,
        // TAMBAHKAN PROPERTI 'actions' DI SINI
        actions: [
          IconButton(
            onPressed: () {
              // Perintah untuk logout dari Firebase
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text('Daftar Replay akan muncul di sini.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReplayPage()),
          );
        },
        tooltip: 'Tambah Replay',
        child: const Icon(Icons.add),
      ),
    );
  }
}