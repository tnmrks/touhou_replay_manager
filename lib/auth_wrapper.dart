import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:touhou_replay_manager/home_page.dart';
import 'package:touhou_replay_manager/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Jika pengguna sudah login, tampilkan HomePage
        if (snapshot.hasData) {
          return const HomePage();
        }
        // Jika belum, tampilkan LoginPage
        else {
          return const LoginPage();
        }
      },
    );
  }
}