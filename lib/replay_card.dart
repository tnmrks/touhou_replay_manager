import 'package:flutter/material.dart';
import 'package:touhou_replay_manager/replay_detail_page.dart'; // Impor halaman detail yang akan kita buat

class ReplayCard extends StatelessWidget {
  final String gameTitle;
  final int score;
  final String character;
  final String documentId; // <-- TAMBAHKAN INI

  const ReplayCard({
    super.key,
    required this.gameTitle,
    required this.score,
    required this.character,
    required this.documentId, // <-- TAMBAHKAN INI
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.videogame_asset_outlined, color: Colors.deepPurple),
        title: Text(
          gameTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Score: $score\nCharacter: $character'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // <-- ISI BAGIAN INI
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReplayDetailPage(replayId: documentId),
            ),
          );
        },
      ),
    );
  }
}