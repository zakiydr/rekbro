// import 'dart:html' as html;
import 'package:web/web.dart' hide Text;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> _sendLoginLink() async {
    print(_emailController.text);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', _emailController.text.trim());

      final origin = window.location.origin;
      final continueUrl = '$origin/verify';

      final actionCodeSettings = ActionCodeSettings(
        url: continueUrl,
        // url: 'https://rekbro.app/verify',
        handleCodeInApp: true,
      );

      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: _emailController.text.trim(),
        actionCodeSettings: actionCodeSettings,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Link telah dikirim! Silakan cek email'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        print(e.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Terjadi error: ${e.message}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Terjadi kesalahan: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(controller: _emailController),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _sendLoginLink,
            child:
                _isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Text('Kirim Link Login'),
          ),
        ],
      ),
    );
  }
}
