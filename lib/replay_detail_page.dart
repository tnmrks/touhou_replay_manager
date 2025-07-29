import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReplayDetailPage extends StatelessWidget {
  final String replayId;

  const ReplayDetailPage({super.key, required this.replayId});

  // Widget kecil untuk menampilkan detail dengan ikon
  Widget detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Replay'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('replays').doc(replayId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data replay tidak ditemukan.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              detailRow(Icons.games, 'Game', data['game_title'] ?? 'N/A'),
              detailRow(Icons.score, 'Score', (data['score'] ?? 0).toString()),
              detailRow(Icons.person, 'Character', data['character'] ?? 'N/A'),
              const Divider(height: 32),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  if (data['is_clear'] == true) const Chip(label: Text('Clear')),
                  if (data['no_miss'] == true) const Chip(label: Text('No Miss')),
                  if (data['no_bomb'] == true) const Chip(label: Text('No Bomb')),
                  if (data['all_spells'] == true) const Chip(label: Text('All Spells Captured')),
                  if (data['is_perfect'] == true) const Chip(label: Text('Perfect')),
                ],
              ),
              if ((data['others'] as String?)?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                Text('Catatan Lain:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(data['others']),
              ]
            ],
          );
        },
      ),
    );
  }
}