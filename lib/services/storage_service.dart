import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> uploadReplayFile({
    required File file,
    required String userId,
  }) async {
    try {
      // Membuat path file yang unik untuk setiap pengguna dan file
      final fileName = file.path.split('/').last;
      final filePath = 'public/replays/$userId/$fileName';

      // Mengunggah file
      await _supabase.storage.from('replays').upload(
            filePath,
            file,
          );

      // Mengambil URL publik dari file yang baru diunggah
      final String publicUrl = _supabase.storage
          .from('replays')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
}