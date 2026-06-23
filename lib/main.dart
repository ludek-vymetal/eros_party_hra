import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/cloud_partner_service.dart';
import 'firebase_options.dart';

import 'screens/partner_menu.dart';
import 'package:flutter/foundation.dart';
import 'party/screens/party_setup_players_screen.dart';
import 'party/screens/party_game_screen.dart';
import 'party/screens/task_manager_screen.dart';

import 'party/services/party_game_persistence.dart';
import 'party/services/task_bank_loader.dart';
import 'party/services/party_game_engine.dart';

// 🔐 AGE GATE
import 'core/age_gate/age_gate_controller.dart';
import 'core/age_gate/age_gate_storage.dart';
import 'core/age_gate/age_gate_screen.dart';
import 'screens/auth_wrapper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// 🌍 L10N
import 'l10n/app_localizations.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb &&
      (Platform.isAndroid || Platform.isIOS)) {

    await FirebaseMessaging.instance.requestPermission();

    final token =
        await FirebaseMessaging.instance.getToken();

    if (token != null) {
      debugPrint('FCM TOKEN: $token');

      await CloudPartnerService.saveFcmToken(
        token,
      );

      debugPrint('FCM TOKEN ULOZEN');
    }
    }
  

  runApp(const MyApp());
}
/// =======================
/// ROOT APP
/// =======================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(
    BuildContext context,
    Locale locale,
  ) {
    final state =
        context.findAncestorStateOfType<
            _MyAppState>();

    state?.changeLocale(locale);
  }

  @override
  State<MyApp> createState() =>
      _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _ageGateController =
      AgeGateController(
    AgeGateStorage(),
  );

  bool _checked = false;
  bool _showAgeGate = true;

  Locale _locale = const Locale(
    'cs',
  );

  void changeLocale(
    Locale locale,
  ) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();

    _checkAgeGate();
  }

  Future<void> _checkAgeGate() async {
    final shouldShow =
        await _ageGateController
            .shouldShowGate();

    if (!mounted) return;

    setState(() {
      _showAgeGate = shouldShow;
      _checked = true;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (!_checked) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child:
                CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      locale: _locale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations
            .delegate,
        GlobalWidgetsLocalizations
            .delegate,
        GlobalCupertinoLocalizations
            .delegate,
      ],

      supportedLocales: const [
        Locale('cs'),
        Locale('en'),
      ],

      theme: ThemeData.dark(),

      home: _showAgeGate
          ? AgeGateScreen(
              controller:
                  _ageGateController,

              onConfirmed: () {
                setState(() {
                  _showAgeGate = false;
                });
              },
            )
          :  const AuthWrapper(),
    );
  }
}

/// =======================
/// MAIN MENU
/// =======================
class MainMenuScreen
    extends StatefulWidget {
  const MainMenuScreen({
    super.key,
  });

  @override
  State<MainMenuScreen>
      createState() =>
          _MainMenuScreenState();
}

class _MainMenuScreenState
    extends State<MainMenuScreen> {
  bool _hasSavedPartyGame = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _checkSavedGame();
  }

  Future<void>
      _checkSavedGame() async {
    final exists =
        await PartyGamePersistence
            .hasSavedGame();

    if (!mounted) return;

    setState(() {
      _hasSavedPartyGame = exists;
      _loading = false;
    });
  }

  Future<void>
      _continuePartyGame() async {
    final navigator =
        Navigator.of(context);

    final state =
        await PartyGamePersistence
            .load();

    if (state == null ||
        !context.mounted) {
      return;
    }

    final taskBank =
        await TaskBankLoader.load();

    if (!context.mounted) return;

    final engine = PartyGameEngine(
      state: state,
      taskBank: taskBank,
    );

    await navigator.push(
      MaterialPageRoute(
        builder: (_) =>
            PartyGameScreen(
          engine: engine,
        ),
      ),
    );

    if (!context.mounted) return;

    _checkSavedGame();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n =
        AppLocalizations.of(context);

    if (_loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EROS'),

        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 12,
            ),

            child: Center(
              child: DropdownButtonHideUnderline(
                  
                child:
                    DropdownButton<
                      Locale
                    >(
                      dropdownColor:
                          Colors
                              .black87,

                      value:
                          Localizations.localeOf(
                        context,
                      ),

                      items: [
                        DropdownMenuItem(
                          value:
                              const Locale(
                            'cs',
                          ),

                          child: Text(
                            l10n.czech,
                          ),
                        ),

                        DropdownMenuItem(
                          value:
                              const Locale(
                            'en',
                          ),

                          child: Text(
                            l10n.english,
                          ),
                        ),
                      ],

                      onChanged: (
                        locale,
                      ) {
                        if (locale !=
                            null) {
                          MyApp.setLocale(
                            context,
                            locale,
                          );
                        }
                      },
                    ),
              ),
            ),
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Text(
              'EROS',

              style: TextStyle(
                fontSize: 42,
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 4,
              ),
            ),

            const SizedBox(
              height: 50,
            ),

            if (_hasSavedPartyGame)
              ...[
                ElevatedButton(
                  onPressed:
                      _continuePartyGame,

                  child: Text(
                    l10n
                        .continuePartyGame,

                    style:
                        const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
              ],

            ElevatedButton(
              onPressed: () async {
                await PartyGamePersistence
                    .clear();

                if (!context.mounted) {
                  return;
                }

                await Navigator.of(
                        context)
                    .push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const PartySetupPlayersScreen(),
                  ),
                );

                if (!context.mounted) {
                  return;
                }

                _checkSavedGame();
              },

              child: Text(
                l10n.newPartyGame,

                style:
                    const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () async {
                await Navigator.of(
                        context)
                    .push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const TaskManagerScreen(),
                  ),
                );
              },

              child: Text(
                l10n.taskManager,

                style:
                    const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            ElevatedButton(
              onPressed: () async {
                await Navigator.of(
                        context)
                    .push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const PartnerMenuScreen(),
                  ),
                );
              },

              child: Text(
                l10n.partnerMode,

                style:
                    const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}