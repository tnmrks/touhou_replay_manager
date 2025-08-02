import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddReplayPage extends StatefulWidget {
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
  final _commentController = TextEditingController(); // <-- BARU: Controller untuk komentar

  String? _selectedGame;
  String? _selectedDifficulty;

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
  final List<String> difficulties = ['Easy', 'Normal', 'Hard', 'Lunatic', 'Extra', 'Phantasm'];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _selectedGame = data['game_title'];
      _selectedDifficulty = data['difficulty'];
      _scoreController.text = (data['score'] ?? 0).toString();
      _characterController.text = data['character'] ?? '';
      _isClear = data['is_clear'] ?? false;
      _noMiss = data['no_miss'] ?? false;
      _noBomb = data['no_bomb'] ?? false;
      _allSpells = data['all_spells'] ?? false;
      _isPerfect = data['is_perfect'] ?? false;
      _showOthersField = (data['others'] as String?)?.isNotEmpty ?? false;
      _othersController.text = data['others'] ?? '';
      _commentController.text = data['comment'] ?? ''; // <-- BARU: Isi field komentar saat edit
    }
  }

  Future<void> saveReplay() async {
    if (_selectedGame == null || _scoreController.text.isEmpty || _selectedDifficulty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul Gim, Skor, dan Kesulitan wajib diisi!')),
      );
      return;
    }

    final replayData = {
      'game_title': _selectedGame,
      'score': int.tryParse(_scoreController.text) ?? 0,
      'character': _characterController.text,
      'difficulty': _selectedDifficulty,
      'timestamp': FieldValue.serverTimestamp(),
      'is_clear': _isClear,
      'no_miss': _noMiss,
      'no_bomb': _noBomb,
      'all_spells': _allSpells,
      'is_perfect': _isPerfect,
      'others': _showOthersField ? _othersController.text.trim() : '',
      'show_others': _showOthersField,
      'comment': _commentController.text.trim(), // <-- BARU: Simpan data komentar
    };

    try {
      if (widget.documentId == null) {
        await FirebaseFirestore.instance.collection('replays').add(replayData);
      } else {
        await FirebaseFirestore.instance.collection('replays').doc(widget.documentId).update(replayData);
      }

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _characterController.dispose();
    _othersController.dispose();
    _commentController.dispose(); // <-- BARU: Dispose controller komentar
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentId == null ? 'Tambah Replay Baru' : 'Edit Replay'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown, Skor, Karakter (tidak berubah)
            DropdownButtonFormField<String>(
              value: _selectedGame,
              decoration: const InputDecoration(labelText: 'Judul Gim', border: OutlineInputBorder()),
              items: touhouGames.map((String game) => DropdownMenuItem<String>(value: game, child: Text(game, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (String? newValue) => setState(() => _selectedGame = newValue),
              isExpanded: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(labelText: 'Tingkat Kesulitan', border: OutlineInputBorder()),
              items: difficulties.map((String difficulty) => DropdownMenuItem<String>(value: difficulty, child: Text(difficulty))).toList(),
              onChanged: (String? newValue) => setState(() => _selectedDifficulty = newValue),
            ),
            const SizedBox(height: 16),
            TextField(controller: _scoreController, decoration: const InputDecoration(labelText: 'Skor', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            TextField(controller: _characterController, decoration: const InputDecoration(labelText: 'Karakter', border: OutlineInputBorder())),
            const Divider(height: 32),

            // Checkbox (tidak berubah)
            CheckboxListTile(title: const Text('Clear'), value: _isClear, onChanged: (val) => setState(() => _isClear = val ?? false), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero),
            CheckboxListTile(title: const Text('No Miss'), value: _noMiss, onChanged: (val) => setState(() => _noMiss = val ?? false), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero),
            CheckboxListTile(title: const Text('No Bomb'), value: _noBomb, onChanged: (val) => setState(() => _noBomb = val ?? false), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero),
            CheckboxListTile(title: const Text('All Spell Cards Captured'), value: _allSpells, onChanged: (val) => setState(() => _allSpells = val ?? false), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero),
            CheckboxListTile(title: const Text('Perfect'), value: _isPerfect, onChanged: (val) => setState(() => _isPerfect = val ?? false), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero),
            CheckboxListTile(
              title: const Text('Kondisi Lainnya'),
              value: _showOthersField,
              onChanged: (bool? value) => setState(() => _showOthersField = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
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

            const Divider(height: 32),

            // <-- WIDGET BARU UNTUK KOMENTAR -->
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                hintText: 'Tulis catatan atau pemikiran Anda tentang replay ini...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4, // Beri ruang lebih untuk mengetik
            ),
            // <-- AKHIR WIDGET BARU -->

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveReplay,
                child: Text(widget.documentId == null ? 'Simpan Replay' : 'Update Replay'),
              ),
            )
          ],
        ),
      ),
    );
  }
}