import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touhou_replay_manager/add_replay_page.dart';

class ReplayDetailPage extends StatefulWidget {
  final String replayId;

  const ReplayDetailPage({super.key, required this.replayId});

  @override
  State<ReplayDetailPage> createState() => _ReplayDetailPageState();
}

class _ReplayDetailPageState extends State<ReplayDetailPage> {
  // Fungsi untuk menampilkan dialog konfirmasi hapus (tidak berubah)
  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus replay ini? Tindakan ini tidak dapat dibatalkan.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteReplay();
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus data dari Firestore (tidak berubah)
  Future<void> _deleteReplay() async {
    try {
      await FirebaseFirestore.instance.collection('replays').doc(widget.replayId).delete();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus replay: $e')),
      );
    }
  }

  // Widget kecil untuk menampilkan baris detail (tidak berubah)
  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[700], size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('replays').doc(widget.replayId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Memuat Replay...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Data replay tidak ditemukan.')),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            title: Text(data['game_title'] ?? 'Detail Replay'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Replay',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddReplayPage(
                        documentId: widget.replayId,
                        initialData: data,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Hapus Replay',
                onPressed: _showDeleteConfirmationDialog,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _detailRow(Icons.games, 'Game', data['game_title'] ?? 'N/A'),
              _detailRow(Icons.score, 'Score', (data['score'] ?? 0).toString()),
              _detailRow(Icons.person, 'Character', data['character'] ?? 'N/A'),
              _detailRow(Icons.star, 'Difficulty', data['difficulty'] ?? 'N/A'),
              const Divider(height: 32, thickness: 1),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  if (data['is_clear'] == true) const Chip(label: Text('Clear'), backgroundColor: Colors.greenAccent),
                  if (data['no_miss'] == true) const Chip(label: Text('No Miss'), backgroundColor: Colors.lightBlueAccent),
                  if (data['no_bomb'] == true) const Chip(label: Text('No Bomb'), backgroundColor: Colors.orangeAccent),
                  if (data['all_spells'] == true) const Chip(label: Text('All Spells Captured'), backgroundColor: Colors.purpleAccent),
                  if (data['is_perfect'] == true) const Chip(label: Text('Perfect'), backgroundColor: Colors.amberAccent),
                ],
              ),
              if ((data['others'] as String?)?.isNotEmpty ?? false) ...[
                const SizedBox(height: 24),
                Text('Catatan Lain:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(data['others']),
                ),
              ],
              
              // <-- BAGIAN BARU UNTUK MENAMPILKAN KOMENTAR -->
              if ((data['comment'] as String?)?.isNotEmpty ?? false) ...[
                const SizedBox(height: 24),
                Text('Komentar:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(data['comment']),
                ),
              ]
              // <-- AKHIR DARI BAGIAN BARU -->
            ],
          ),
        );
      },
    );
  }
}