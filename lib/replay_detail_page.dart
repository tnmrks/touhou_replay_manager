import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Ubah menjadi StatefulWidget
class ReplayDetailPage extends StatefulWidget {
  final String replayId;

  const ReplayDetailPage({super.key, required this.replayId});

  @override
  State<ReplayDetailPage> createState() => _ReplayDetailPageState();
}

class _ReplayDetailPageState extends State<ReplayDetailPage> {

  // --- FUNGSI BARU UNTUK HAPUS DATA ---
  Future<void> _deleteReplay() async {
    try {
      // Hapus dokumen dari Firestore berdasarkan ID-nya
      await FirebaseFirestore.instance.collection('replays').doc(widget.replayId).delete();

      // Kembali ke halaman sebelumnya setelah berhasil menghapus
      if (!mounted) return;
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus replay: $e')),
      );
    }
  }
  
  // --- FUNGSI BARU UNTUK MENAMPILKAN DIALOG KONFIRMASI ---
  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User harus menekan tombol
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin menghapus replay ini?'),
                Text('Tindakan ini tidak dapat dibatalkan.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog dulu
                _deleteReplay(); // Jalankan fungsi hapus
              },
            ),
          ],
        );
      },
    );
  }

  // Widget kecil untuk menampilkan detail dengan ikon (tidak berubah)
  Widget detailRow(IconData icon, String label, String value) {
    // ... (kode ini sama seperti sebelumnya, tidak perlu diubah) ...
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
        // --- TAMBAHKAN TOMBOL HAPUS DI SINI ---
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus Replay',
            onPressed: _showDeleteConfirmationDialog, // Panggil dialog konfirmasi
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('replays').doc(widget.replayId).get(),
        builder: (context, snapshot) {
          // ... (sisa kode FutureBuilder tidak berubah) ...
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