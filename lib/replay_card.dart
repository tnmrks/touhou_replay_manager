import 'package:flutter/material.dart';

class ReplayCard extends StatelessWidget {
  const ReplayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.videogame_asset_outlined),
        title: const Text('Judul Gim Replay'),
        subtitle: const Text('Info Skor dan Karakter'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Aksi saat item di-klik
        },
      ),
    );
  }
}