import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddReplayPage extends StatefulWidget {
  // Tambahkan variabel untuk menerima data saat mode edit
  final String? documentId;
  final Map<String, dynamic>? initialData;

  const AddReplayPage({super.key, this.documentId, this.initialData});

  @override
  State<AddReplayPage> createState() => _AddReplayPageState();
}

class _AddReplayPageState extends State<AddReplayPage> {
  // --- KUMPULAN VARIABLE STATE ---
  final _scoreController = TextEditingController();
  final _characterController = TextEditingController();
  final _othersController = TextEditingController();

  String? _selectedGame;
  bool _isClear = false;
  bool _noMiss = false;
  bool _noBomb = false;
  bool _allSpells = false;
  bool _isPerfect = false;
  bool _showOthersField = false;

  final List<String> touhouGames = [
    "TH01: Highly Responsive to Prayers", "TH02: Story of Eastern Wonderland",
    "TH03: Phantasmagoria of Dim.Dream", "TH04: Lotus Land Story",
    "TH05: Mystic Square", "TH06: Embodiment of Scarlet Devil",
    "TH07: Perfect Cherry Blossom", "TH08: Imperishable Night",
    "TH09: Phantasmagoria of Flower View", "TH10: Mountain of Faith",
    "TH11: Subterranean Animism", "TH12: Undefined Fantastic Object",
    "TH13: Ten Desires", "TH14: Double Dealing Character",
    "TH15: Legacy of Lunatic Kingdom", "TH16: Hidden Star in Four Seasons",
    "TH17: Wily Beast and Weakest Creature", "TH18: Unconnected Marketeers",
    "TH19: Unfinished Dream of All Living Ghost", "TH20: Fossilized Wonders"
  ];

  @override
  void initState() {
    super.initState();
    // Jika ada data awal (mode edit), isi form dengan data tersebut
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _selectedGame = data['game_title'];
      _scoreController.text = (data['score'] ?? 0).toString();
      _characterController.text = data['character'] ?? '';
      _isClear = data['is_clear'] ?? false;
      _noMiss = data['no_miss'] ?? false;
      _noBomb = data['no_bomb'] ?? false;
      _allSpells = data['all_spells'] ?? false;
      _isPerfect = data['is_perfect'] ?? false;
      _showOthersField = (data['others'] as String?)?.isNotEmpty ?? false;
      _othersController.text = data['others'] ?? '';
    }
  }

  // Logika simpan akan kita perbaiki besok agar bisa handle update
  Future<void> saveReplay() async {
    // ... (kode ini akan kita modifikasi besok) ...
  }
  
  @override
  void dispose() {
    _scoreController.dispose();
    _characterController.dispose();
    _othersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Judul berubah tergantung mode (tambah/edit)
        title: Text(widget.documentId == null ? 'Tambah Replay Baru' : 'Edit Replay'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedGame,
              decoration: const InputDecoration(labelText: 'Judul Gim', border: OutlineInputBorder()),
              items: touhouGames.map((String game) {
                return DropdownMenuItem<String>(value: game, child: Text(game, overflow: TextOverflow.ellipsis));
              }).toList(),
              onChanged: (String? newValue) => setState(() => _selectedGame = newValue),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _scoreController,
              decoration: const InputDecoration(labelText: 'Skor', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _characterController,
              decoration: const InputDecoration(labelText: 'Karakter', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Clear'),
              value: _isClear,
              onChanged: (bool? value) => setState(() => _isClear = value ?? false),
              controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('No Miss'),
              value: _noMiss,
              onChanged: (bool? value) => setState(() => _noMiss = value ?? false),
              controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('No Bomb'),
              value: _noBomb,
              onChanged: (bool? value) => setState(() => _noBomb = value ?? false),
              controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('All Spell Cards Captured'),
              value: _allSpells,
              onChanged: (bool? value) => setState(() => _allSpells = value ?? false), // TYPO HERE, should be _allSpells
              controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Perfect'),
              value: _isPerfect,
              onChanged: (bool? value) => setState(() => _isPerfect = value ?? false),
              controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Kondisi Lainnya'),
              value: _showOthersField,
              onChanged: (bool? value) => setState(() => _showOthersField = value ?? false),
              controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero,
            ),
            Visibility(
              visible: _showOthersField,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _othersController,
                  decoration: const InputDecoration(labelText: 'Tulis kondisi lainnya...', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
              ),
            ),
            const SizedBox(height: 24),
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