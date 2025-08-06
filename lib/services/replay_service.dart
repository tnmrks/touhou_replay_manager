// File: lib/services/replay_service.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:touhou_replay_manager/services/storage_service.dart';

class ReplayService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storageService = StorageService();

  Future<String?> saveReplay({
    String? documentId,
    required Map<String, dynamic> replayData,
    File? fileToUpload,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return "Pengguna tidak login.";
      }

      // 1. Upload file jika ada
      String? fileUrl;
      if (fileToUpload != null) {
        fileUrl = await _storageService.uploadReplayFile(
          file: fileToUpload,
          userId: user.uid,
        );
        if (fileUrl == null) {
          return "Gagal mengunggah file.";
        }
      }
      
      // 2. Tambahkan info pengguna dan URL file ke data
      replayData['user_id'] = user.uid;
      if (fileUrl != null) {
        replayData['file_url'] = fileUrl;
      }

      // 3. Simpan atau update data di Firestore
      if (documentId == null) {
        // Mode Tambah Baru
        await _firestore.collection('replays').add(replayData);
      } else {
        // Mode Edit
        await _firestore.collection('replays').doc(documentId).update(replayData);
      }
      
      return 'success'; // Mengembalikan string sukses
    } on FirebaseException catch (e) {
      return e.message ?? "Terjadi kesalahan Firebase.";
    } catch (e) {
      return e.toString();
    }
  }
}