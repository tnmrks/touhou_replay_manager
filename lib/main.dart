import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:touhou_replay_manager/auth_wrapper.dart';

import 'env.dart'; // <-- Impor file baru kita

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); // Inisialisasi Firebase

  // --- Gunakan variabel dari class Env ---
  await Supabase.initialize(
    url: Env.supabaseUrl,     // <-- Ambil dari file env.dart
    anonKey: Env.supabaseAnonKey, // <-- Ambil dari file env.dart
  );
  // ------------------------------------

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Touhou Replay Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}