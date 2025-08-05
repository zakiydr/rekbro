import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyScreen extends StatefulWidget {
  final String link;
  const VerifyScreen({super.key, required this.link});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  Future<void> _verifySignIn() async {
    final prefs = await SharedPreferences.getInstance();

    final email = prefs.getString('user_email');

    if (email != null &&
        FirebaseAuth.instance.isSignInWithEmailLink(widget.link)) {
      try {
        await FirebaseAuth.instance.signInWithEmailLink(
          email: email,
          emailLink: widget.link,
        );

        await prefs.remove('user_email');

        if (mounted) {
          context.go('/home');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error saat verifikasi: $e')));
          context.go('/login');
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link tidak valid atau sudah kedaluwarsa.'),
          ),
        );
        context.go('/login'); // Lempar kembali ke login
      }
    }
  }

  @override
  void initState() {
    _verifySignIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
