import 'package:flutter/material.dart';

class AddReplayPage extends StatelessWidget {
  const AddReplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold adalah kerangka dasar untuk sebuah halaman
    return Scaffold(
      // AppBar adalah bar judul di bagian atas
      appBar: AppBar(
        title: const Text('Tambah Replay Baru'),
        backgroundColor: Colors.blueGrey, // Warna agar beda dari halaman utama
      ),
      // Body adalah konten utama halaman
      body: const Center(
        child: Text('Formulir untuk menambah replay akan ada di sini.'),
      ),
    );
  }
}