import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_replay_page.dart';
import 'replay_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: ListView.builder(
  itemCount: 5, // Kita buat 5 item tiruan
  itemBuilder: (context, index) {
    return const ReplayCard();
  },
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