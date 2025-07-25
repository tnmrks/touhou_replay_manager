import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddReplayPage extends StatefulWidget {
  const AddReplayPage({super.key});

  @override
  State<AddReplayPage> createState() => _AddReplayPageState();
}

class _AddReplayPageState extends State<AddReplayPage> {
  // --- KUMPULAN VARIABLE STATE ---

  // Controller untuk field teks
  final _scoreController = TextEditingController();
  final _characterController = TextEditingController();
  final _othersController = TextEditingController();

  // Variabel untuk dropdown
  String? _selectedGame;

  // Daftar judul gim
  final List<String> touhouGames = [
    "TH01: Highly Responsive to Prayers",
    "TH02: Story of Eastern Wonderland",
    "TH03: Phantasmagoria of Dim.Dream",
    "TH04: Lotus Land Story",
    "TH05: Mystic Square",
    "TH06: Embodiment of Scarlet Devil",
    "TH07: Perfect Cherry Blossom",
    "TH08: Imperishable Night",
    "TH09: Phantasmagoria of Flower View",
    "TH10: Mountain of Faith",
    "TH11: Subterranean Animism",
    "TH12: Undefined Fantastic Object",
    "TH13: Ten Desires",
    "TH14: Double Dealing Character",
    "TH15: Legacy of Lunatic Kingdom",
    "TH16: Hidden Star in Four Seasons",
    "TH17: Wily Beast and Weakest Creature",
    "TH18: Unconnected Marketeers",
    "TH19: Unfinished Dream of All Living Ghost",
    "TH20: Fossilized Wonders"
  ];

  // Variabel untuk checkbox
  bool _isClear = false;
  bool _noMiss = false;
  bool _noBomb = false;
  bool _allSpells = false;
  bool _isPerfect = false;
  bool _showOthersField = false; // Untuk mengontrol field "Others"

  // --- FUNGSI-FUNGSI ---

  // Fungsi untuk menyimpan data ke Firestore
  Future<void> saveReplay() async {
    // Validasi sederhana
    if (_selectedGame == null || _scoreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul Gim dan Skor tidak boleh kosong!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('replays').add({
        'game_title': _selectedGame,
        'score': int.tryParse(_scoreController.text) ?? 0,
        'character': _characterController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'is_clear': _isClear,
        'no_miss': _noMiss,
        'no_bomb': _noBomb,
        'all_spells': _allSpells,
        'is_perfect': _isPerfect,
        // Simpan teks 'others' hanya jika checkbox-nya dicentang
        'others': _showOthersField ? _othersController.text.trim() : '',
      });

      if (!mounted) return;
      Navigator.pop(context); // Kembali ke halaman utama jika berhasil
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  // Membersihkan controller saat widget tidak lagi digunakan
  @override
  void dispose() {
    _scoreController.dispose();
    _characterController.dispose();
    _othersController.dispose();
    super.dispose();
  }

  // --- TAMPILAN UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Replay Baru'),
        backgroundColor: Colors.blueGrey,
      ),
      // Gunakan SingleChildScrollView agar halaman bisa di-scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown untuk Judul Gim
            DropdownButtonFormField<String>(
              value: _selectedGame,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Judul Gim',
                border: OutlineInputBorder(),
              ),
              items: touhouGames.map((String game) {
                return DropdownMenuItem<String>(
                  value: game,
                  child: Text(game, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGame = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            // TextField untuk Skor
            TextField(
              controller: _scoreController,
              decoration: const InputDecoration(labelText: 'Skor', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // TextField untuk Karakter
            TextField(
              controller: _characterController,
              decoration: const InputDecoration(labelText: 'Karakter', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Divider(), // Garis pemisah
            
            // Kumpulan Checkbox
            CheckboxListTile(
              title: const Text('Clear'),
              value: _isClear,
              onChanged: (bool? value) => setState(() => _isClear = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('No Miss'),
              value: _noMiss,
              onChanged: (bool? value) => setState(() => _noMiss = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('No Bomb'),
              value: _noBomb,
              onChanged: (bool? value) => setState(() => _noBomb = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('All Spell Cards Captured'),
              value: _allSpells,
              onChanged: (bool? value) => setState(() => _allSpells = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Perfect'),
              value: _isPerfect,
              onChanged: (bool? value) => setState(() => _isPerfect = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Kondisi Lainnya'),
              value: _showOthersField,
              onChanged: (bool? value) => setState(() => _showOthersField = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            // TextField "Others" yang hanya muncul jika checkbox-nya dicentang
            Visibility(
              visible: _showOthersField,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: TextField(
                  controller: _othersController,
                  decoration: const InputDecoration(
                    labelText: 'Tulis kondisi lainnya...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveReplay,
                child: const Text('Simpan Replay'),
              ),
            )
          ],
        ),
      ),
    );
  }
}