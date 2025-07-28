import 'package:flutter/material.dart';

class ReplayCard extends StatelessWidget {
  // 1. Tambahkan variabel untuk menampung data
  final String gameTitle;
  final int score;
  final String character;

  // 2. Buat constructor untuk menerima data
  const ReplayCard({
    super.key,
    required this.gameTitle,
    required this.score,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.videogame_asset_outlined, color: Colors.deepPurple),
        // 3. Gunakan data yang diterima untuk ditampilkan di UI
        title: Text(
          gameTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Score: $score\nCharacter: $character'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Aksi saat item di-klik akan kita tambahkan di sesi berikutnya
        },
      ),
    );
  }
}