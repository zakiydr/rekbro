import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data user yang sedang login.
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Setelah logout, kembali ke halaman login.
              context.go('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Selamat datang!\nAnda berhasil login sebagai:\n${user?.email}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}