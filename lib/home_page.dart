import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Pastikan import ini ada
import 'package:flutter/material.dart';
import 'package:touhou_replay_manager/add_replay_page.dart';
import 'package:touhou_replay_manager/replay_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Dapatkan ID pengguna yang sedang login
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Touhou Replay Manager'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // --- PERUBAHAN UTAMA ADA DI SINI ---
        stream: FirebaseFirestore.instance
            .collection('replays')
            .where('userId', isEqualTo: currentUserId) // Filter data berdasarkan userId
            .snapshots(),
        // --- AKHIR DARI PERUBAHAN ---
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada replay. Tambahkan satu!'));
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan saat memuat data.'));
          }

          final replayDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: replayDocs.length,
            itemBuilder: (context, index) {
              final doc = replayDocs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ReplayCard(
                documentId: doc.id,
                gameTitle: data['game_title'] ?? 'Unknown Game',
                score: data['score'] ?? 0,
                character: data['character'] ?? 'Unknown Character',
              );
            },
          );
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