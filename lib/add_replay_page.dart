import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:touhou_replay_manager/services/replay_service.dart';

class AddReplayPage extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? initialData;

  const AddReplayPage({super.key, this.documentId, this.initialData});

  @override
  State<AddReplayPage> createState() => _AddReplayPageState();
}

class _AddReplayPageState extends State<AddReplayPage> {
  // --- STATE & CONTROLLERS ---
  final _replayService = ReplayService();
  bool _isLoading = false;
  File? _selectedFile;

  final _scoreController = TextEditingController();
  final _characterController = TextEditingController();
  final _othersController = TextEditingController();
  final _commentController = TextEditingController();

  String? _selectedGame;
  String? _selectedDifficulty;

  bool _isClear = false;
  bool _noMiss = false;
  bool _noBomb = false;
  bool _allSpells = false;
  bool _isPerfect = false;
  bool _showOthersTextField = false;

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
    "TH19: Unfinished Dream of All Living Ghost", "TH20: Touhou Jououen (WIP)"
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
      _showOthersTextField = (data['others'] as String?)?.isNotEmpty ?? false;
      _othersController.text = data['others'] ?? '';
      _commentController.text = data['comment'] ?? '';
    }
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _characterController.dispose();
    _othersController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // --- LOGIC FUNCTIONS ---

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['rpy', 'mp4', 'avi', 'mkv'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tidak bisa mengambil file: $e")),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_selectedGame == null || _scoreController.text.isEmpty || _selectedDifficulty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul Gim, Skor, dan Kesulitan wajib diisi!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final replayData = {
      'game_title': _selectedGame,
      'score': int.tryParse(_scoreController.text) ?? 0,
      'character': _characterController.text.trim(),
      'difficulty': _selectedDifficulty,
      'is_clear': _isClear,
      'no_miss': _noMiss,
      'no_bomb': _noBomb,
      'all_spells': _allSpells,
      'is_perfect': _isPerfect,
      'others': _showOthersTextField ? _othersController.text.trim() : '',
      'comment': _commentController.text.trim(),
    };

    final result = await _replayService.saveReplay(
      documentId: widget.documentId,
      replayData: replayData,
      fileToUpload: _selectedFile,
    );

    if (!mounted) return;

    if (result == 'success') {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Terjadi kesalahan.')),
      );
    }
    
    setState(() => _isLoading = false);
  }

  // --- UI (WIDGET BUILD) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentId == null ? 'Tambah Replay Baru' : 'Edit Replay'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Judul Gim
            DropdownButtonFormField<String>(
              value: _selectedGame,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Judul Gim', border: OutlineInputBorder()),
              items: touhouGames.map((String game) => DropdownMenuItem<String>(value: game, child: Text(game, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (String? newValue) => setState(() => _selectedGame = newValue),
            ),
            const SizedBox(height: 16),

            // Dropdown Tingkat Kesulitan
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(labelText: 'Tingkat Kesulitan', border: OutlineInputBorder()),
              items: difficulties.map((String difficulty) => DropdownMenuItem<String>(value: difficulty, child: Text(difficulty))).toList(),
              onChanged: (String? newValue) => setState(() => _selectedDifficulty = newValue),
            ),
            const SizedBox(height: 16),
            
            // TextField Skor & Karakter
            TextField(controller: _scoreController, decoration: const InputDecoration(labelText: 'Skor', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            TextField(controller: _characterController, decoration: const InputDecoration(labelText: 'Karakter', border: OutlineInputBorder())),
            const SizedBox(height: 16),

            // Bagian Pilih File
            Row(
              children: [
                OutlinedButton.icon(onPressed: _pickFile, icon: const Icon(Icons.attach_file), label: const Text('Pilih File Replay')),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedFile != null ? _selectedFile!.path.split(Platform.isWindows ? '\\' : '/').last : 'Belum ada file dipilih',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            
            // Kumpulan Checkbox
            CheckboxListTile(title: const Text('Clear'), value: _isClear, onChanged: (val) => setState(() => _isClear = val ?? false), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero),
            CheckboxListTile(title: const Text('No Miss'), value: _noMiss, onChanged: (val) => setState(() => _noMiss = val ?? false), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero),
            CheckboxListTile(title: const Text('No Bomb'), value: _noBomb, onChanged: (val) => setState(() => _noBomb = val ?? false), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero),
            CheckboxListTile(title: const Text('All Spell Cards Captured'), value: _allSpells, onChanged: (val) => setState(() => _allSpells = val ?? false), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero),
            CheckboxListTile(title: const Text('Perfect'), value: _isPerfect, onChanged: (val) => setState(() => _isPerfect = val ?? false), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero),
            
            // Checkbox & TextField "Others"
            CheckboxListTile(
              title: const Text('Kondisi Lainnya'),
              value: _showOthersTextField,
              onChanged: (bool? value) => setState(() => _showOthersTextField = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            Visibility(
              visible: _showOthersTextField,
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
            TextField(controller: _commentController, decoration: const InputDecoration(labelText: 'Komentar', hintText: 'Tulis catatan...', border: OutlineInputBorder()), maxLines: 4),
            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.documentId == null ? 'Simpan Replay' : 'Update Replay'),
              ),
            )
          ],
        ),
      ),
    );
  }
}