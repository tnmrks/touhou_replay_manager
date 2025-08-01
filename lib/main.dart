import 'package:flutter/material.dart';
// Impor file baru
import 'package:firebase_core/firebase_core.dart';
import 'package:touhou_replay_manager/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase akan sedikit berbeda tanpa flutterfire_cli
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touhou Replay Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthWrapper(), // Halaman utama kita
    );
  }
}