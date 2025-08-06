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

      // 1. Unggah file jika ada
      String? fileUrl;
      // Cek juga apakah data awal sudah punya URL, jika tidak ada file baru, gunakan yang lama
      String? existingFileUrl = (replayData['file_url'] as String?);

      if (fileToUpload != null) {
        fileUrl = await _storageService.uploadReplayFile(
          file: fileToUpload,
          userId: user.uid,
        );
        if (fileUrl == null) {
          return "Gagal mengunggah file.";
        }
      }

      // 2. Siapkan data final untuk Firestore
      final Map<String, dynamic> finalData = {
        ...replayData, // Salin semua data dari form
        'userId': user.uid, // <-- INI BAGIAN PENTING YANG DITAMBAHKAN
        'file_url': fileUrl ?? existingFileUrl, // Gunakan URL baru, atau yang lama jika tidak ada file baru
      };

      // 3. Simpan atau update data di Firestore
      if (documentId == null) {
        // Mode Tambah Baru
        await _firestore.collection('replays').add(finalData);
      } else {
        // Mode Edit
        await _firestore.collection('replays').doc(documentId).update(finalData);
      }
      
      return 'success'; // Mengembalikan string sukses
    } on FirebaseException catch (e) {
      return e.message ?? "Terjadi kesalahan Firebase.";
    } catch (e) {
      return e.toString();
    }
  }

  // Kita juga bisa pindahkan fungsi hapus ke sini agar lebih terorganisir
  Future<String?> deleteReplay(String documentId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return "Pengguna tidak login.";
      }
      
      // TODO: Tambahkan logika untuk menghapus file dari Supabase Storage di sini nanti.
      
      await _firestore.collection('replays').doc(documentId).delete();
      return 'success';
    } on FirebaseException catch (e) {
      return e.message ?? "Gagal menghapus replay.";
    }
  }
}