import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final _emailController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  String? errorMessage;

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email:
            _emailController.text.trim(),
        password:
            _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> _register() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email:
            _emailController.text.trim(),
        password:
            _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EROS Login'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration:
                  const InputDecoration(
                labelText: 'Email',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  _passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText: 'Password',
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _login,
              child: const Text(
                'Přihlásit',
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _register,
              child: const Text(
                'Registrovat',
              ),
            ),

            if (errorMessage != null)
              Padding(
                padding:
                    const EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  errorMessage!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}