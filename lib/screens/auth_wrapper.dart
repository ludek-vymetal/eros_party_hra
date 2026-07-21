import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../relationship_book/services/partner_service.dart';
import 'login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() =>
      _AuthWrapperState();
}

class _AuthWrapperState
    extends State<AuthWrapper> {

  bool _initialized = false;

  Future<void> _initializePartner() async {
    if (_initialized) {
      return;
    }

    _initialized = true;

    await PartnerService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:
          FirebaseAuth.instance
              .authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return FutureBuilder<void>(
            future: _initializePartner(),
            builder: (context, initSnapshot) {
              if (initSnapshot.connectionState !=
                  ConnectionState.done) {
                return const Scaffold(
                  body: Center(
                    child:
                        CircularProgressIndicator(),
                  ),
                );
              }

              return const MainMenuScreen();
            },
          );
        }

        _initialized = false;
        PartnerService.clear();

        return const LoginScreen();
      },
    );
  }
}