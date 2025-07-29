import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        // Mengambil data dari koleksi 'replays' di Firestore
        stream: FirebaseFirestore.instance.collection('replays').snapshots(),
        builder: (context, snapshot) {
          // Menampilkan indikator loading saat data sedang diambil
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Menampilkan pesan jika tidak ada data atau terjadi error
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada replay. Tambahkan satu!'));
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan saat memuat data.'));
          }

          // Jika data ada, simpan dalam sebuah variabel
          final replayDocs = snapshot.data!.docs;

          // Bangun daftar menggunakan ListView.builder
          return ListView.builder(
            itemCount: replayDocs.length,
            itemBuilder: (context, index) {
              // Ambil data dari setiap dokumen
              final doc = replayDocs[index];
              final data = doc.data() as Map<String, dynamic>;

              // Buat ReplayCard dengan data dari Firestore
              return ReplayCard(
                // KIRIM ID DOKUMEN KE REPLAYCARD
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