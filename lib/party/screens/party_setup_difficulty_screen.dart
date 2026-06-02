import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

import '../models/setup_player.dart';
import '../models/player.dart';
import '../models/game_state.dart';

import '../services/party_game_engine.dart';
import '../services/task_bank_loader.dart';

import 'party_game_screen.dart';
import 'party_consent_screen.dart';

class PartySetupDifficultyScreen
    extends StatefulWidget {
  final List<SetupPlayer> players;

  const PartySetupDifficultyScreen({
    super.key,
    required this.players,
  });

  @override
  State<PartySetupDifficultyScreen>
      createState() =>
          _PartySetupDifficultyScreenState();
}

class _PartySetupDifficultyScreenState
    extends State<
        PartySetupDifficultyScreen> {
  int _difficulty = 1;

  Future<void> _startGame() async {
    final navigator =
        Navigator.of(context);

    final consent =
        await navigator.push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            const PartyConsentScreen(),
      ),
    );

    if (consent != true ||
        !mounted) {
      return;
    }

    final partyPlayers =
        widget.players.map((p) {
      if (p.clothes.isEmpty) {
        throw Exception(
          'Hráč ${p.name} nemá žádné oblečení',
        );
      }

      return PartyPlayer(
        name: p.name,
        gender: p.gender,
        clothes: List.of(
          p.clothes,
        ),
        specialClothing:
            p.clothes.first,
      );
    }).toList();

    final state = PartyGameState(
      players: partyPlayers,
      difficulty: _difficulty,
    );

    for (final p in widget.players) {
      debugPrint(
        '👕 ${p.name}: ${p.clothes}',
      );
    }

    final taskBank =
        await TaskBankLoader.load();

    if (!mounted) return;

    final engine = PartyGameEngine(
      state: state,
      taskBank: taskBank,
    );

    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            PartyGameScreen(
          engine: engine,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.gameDifficulty,
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
            RadioGroup<int>(
              groupValue: _difficulty,
              onChanged: (value) {
                setState(() {
                  _difficulty =
                      value!;
                });
              },
              child: Column(
                children: [
                  RadioListTile<int>(
                    title: Text(
                      l10n
                          .difficultyEasy,
                    ),
                    value: 1,
                  ),

                  RadioListTile<int>(
                    title: Text(
                      l10n
                          .difficultyMedium,
                    ),
                    value: 2,
                  ),

                  RadioListTile<int>(
                    title: Text(
                      l10n
                          .difficultyHard,
                    ),
                    value: 3,
                  ),
                ],
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: _startGame,
              child: Text(
                l10n.startGame,
              ),
            ),
          ],
        ),
      ),
    );
  }
}