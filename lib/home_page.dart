import 'package:flutter/material.dart';
import 'add_replay_page.dart'; // <-- TAMBAHKAN BARIS INI

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Di dalam file home_page.dart

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Touhou Replay Manager'),
      backgroundColor: Colors.indigo,
    ),
    body: const Center(
      child: Text('Daftar Replay akan muncul di sini.'),
    ),
    // TAMBAHKAN KODE DI BAWAH INI
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Ini adalah aksi saat tombol ditekan.
        // Navigator.push akan "mendorong" halaman baru ke atas halaman saat ini.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddReplayPage()),
        );
      },
      tooltip: 'Tambah Replay',
      child: const Icon(Icons.add),
    ),
    // AKHIR DARI KODE TAMBAHAN
  );
}
}