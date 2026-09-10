import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/cloud_partner_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final _nameController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  String? errorMessage;

  bool _isRegistering = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // ==========================================================
  // LOGIN
  // ==========================================================

  Future<void> _login() async {
    setState(() {
      errorMessage = null;
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email:
            _emailController.text.trim(),
        password:
            _passwordController.text,
      );

      await CloudPartnerService
          .ensureUserDocument();

      // ------------------------------------------------------
      // KONTROLA JMÉNA STARŠÍHO UŽIVATELE
      // ------------------------------------------------------

      final displayName =
          await CloudPartnerService.getMyDisplayName();

      debugPrint('==============================');
      debugPrint('DISPLAY NAME: $displayName');
      debugPrint('==============================');

      if (!mounted) return;

      // Starší účet ještě nemá uložené jméno.
      if (displayName == null ||
          displayName.trim().isEmpty) {
        await _showDisplayNameDialog();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage =
            e.message ??
                'Nepodařilo se přihlásit.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // REGISTER
  // ==========================================================

  Future<void> _register() async {
    final displayName =
        _nameController.text.trim();

    if (displayName.isEmpty) {
      setState(() {
        errorMessage =
            'Zadej prosím své jméno.';
      });

      return;
    }

    if (_emailController.text
        .trim()
        .isEmpty) {
      setState(() {
        errorMessage =
            'Zadej prosím email.';
      });

      return;
    }

    if (_passwordController.text
        .isEmpty) {
      setState(() {
        errorMessage =
            'Zadej prosím heslo.';
      });

      return;
    }

    setState(() {
      errorMessage = null;
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email:
            _emailController.text.trim(),
        password:
            _passwordController.text,
      );

      await CloudPartnerService
          .ensureUserDocument();

      await CloudPartnerService
          .saveDisplayName(
        displayName,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Účet byl úspěšně vytvořen.',
          ),
        ),
      );

      setState(() {
        _isRegistering = false;
        _nameController.clear();
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage =
            e.message ??
                'Registrace se nezdařila.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // DOPLNĚNÍ JMÉNA PRO STARŠÍ ÚČET
  // ==========================================================

  Future<void> _showDisplayNameDialog() async {
    final controller =
        TextEditingController();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Jak ti máme říkat?',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization:
                TextCapitalization.words,
            decoration:
                const InputDecoration(
              hintText: 'Například Luděk',
              prefixIcon:
                  Icon(Icons.person),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final name =
                    controller.text.trim();

                if (name.isEmpty) {
                  return;
                }

                await CloudPartnerService
                    .saveDisplayName(
                  name,
                );

                if (dialogContext.mounted) {
                  Navigator.of(dialogContext)
                      .pop();
                }
              },
              child: const Text(
                'Pokračovat',
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  // ==========================================================
  // UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isRegistering
              ? 'Vytvořit účet'
              : 'EROS Login',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [

                // ==================================================
                // JMÉNO – POUZE REGISTRACE
                // ==================================================

                if (_isRegistering) ...[
                  TextField(
                    controller:
                        _nameController,
                    enabled: !_isLoading,
                    textCapitalization:
                        TextCapitalization.words,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Jak ti máme říkat?',
                      hintText:
                          'Například Luděk',
                      prefixIcon:
                          Icon(Icons.person),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],

                // ==================================================
                // EMAIL
                // ==================================================

                TextField(
                  controller:
                      _emailController,
                  enabled: !_isLoading,
                  keyboardType:
                      TextInputType.emailAddress,
                  autofillHints:
                      const [AutofillHints.email],
                  decoration:
                      const InputDecoration(
                    labelText: 'Email',
                    prefixIcon:
                        Icon(Icons.email),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // HESLO
                // ==================================================

                TextField(
                  controller:
                      _passwordController,
                  enabled: !_isLoading,
                  obscureText: true,
                  autofillHints:
                      const [AutofillHints.password],
                  decoration:
                      const InputDecoration(
                    labelText: 'Heslo',
                    prefixIcon:
                        Icon(Icons.lock),
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // LOGIN / REGISTER
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : (_isRegistering
                            ? _register
                            : _login),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _isRegistering
                                ? 'Vytvořit účet'
                                : 'Přihlásit',
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isRegistering =
                                !_isRegistering;

                            errorMessage = null;

                            _nameController.clear();
                          });
                        },
                  child: Text(
                    _isRegistering
                        ? 'Už máš účet? Přihlásit se'
                        : 'Nemáš účet? Registrovat se',
                  ),
                ),

                // ==================================================
                // ERROR
                // ==================================================

                if (errorMessage != null)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Text(
                      errorMessage!,
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}