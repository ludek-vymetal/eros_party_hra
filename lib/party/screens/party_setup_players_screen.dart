import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

import '../models/setup_player.dart';
import '../models/player.dart';

import 'party_setup_clothes_screen.dart';
import 'party_setup_difficulty_screen.dart';

class PartySetupPlayersScreen extends StatefulWidget {
  const PartySetupPlayersScreen({
    super.key,
  });

  @override
  State<PartySetupPlayersScreen> createState() =>
      _PartySetupPlayersScreenState();
}

class _PartySetupPlayersScreenState
    extends State<PartySetupPlayersScreen> {
  final List<SetupPlayer> _players = [];

  final TextEditingController
      _nameController =
      TextEditingController();

  Gender _selectedGender =
      Gender.male;

  Future<bool> _showConsentDialog(
    String name,
  ) async {
    final l10n =
        AppLocalizations.of(context)!;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: Text(
              l10n.partyConsentTitle,
            ),
            content: Text(
              '$name,\n\n'
              '${l10n.partyConsentText}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false);
                },
                child: Text(
                  l10n.disagree,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(true);
                },
                child: Text(
                  l10n.agree,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _addPlayer() async {
    final l10n =
        AppLocalizations.of(context)!;

    final name =
        _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            l10n.enterPlayerName,
          ),
        ),
      );
      return;
    }

    final consent =
        await _showConsentDialog(name);

    if (!mounted) return;

    if (!consent) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '$name ${l10n.playerNotParticipating}',
          ),
        ),
      );

      _nameController.clear();
      return;
    }

    final player = SetupPlayer(
      name: name,
      gender: _selectedGender,
      clothes: [],
    );

    setState(() {
      _players.add(player);

      _nameController.clear();

      _selectedGender =
          Gender.male;
    });

    await _editClothes(player);

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _editClothes(
    SetupPlayer player,
  ) async {
    final navigator =
        Navigator.of(context);

    await navigator.push(
      MaterialPageRoute(
        builder: (_) =>
            PartySetupClothesScreen(
          player: player,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  bool get _canContinue =>
      _players.length >= 2 &&
      _players.every(
        (p) => p.clothes.isNotEmpty,
      );

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.newPartyGamePlayers,
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller:
                  _nameController,
              decoration:
                  InputDecoration(
                labelText:
                    l10n.playerName,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            RadioGroup<Gender>(
              groupValue:
                  _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender =
                      value!;
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child:
                        RadioListTile<
                            Gender>(
                      title: Text(
                        l10n.male,
                      ),
                      value:
                          Gender.male,
                    ),
                  ),
                  Expanded(
                    child:
                        RadioListTile<
                            Gender>(
                      title: Text(
                        l10n.female,
                      ),
                      value:
                          Gender
                              .female,
                    ),
                  ),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: _addPlayer,
              child: Text(
                l10n.addPlayer,
              ),
            ),

            const Divider(
              height: 32,
            ),

            Expanded(
              child: ListView.builder(
                itemCount:
                    _players.length,
                itemBuilder:
                    (_, index) {
                  final p =
                      _players[index];

                  return ListTile(
                    title: Text(
                      p.name,
                    ),
                    subtitle: Text(
                      p.gender ==
                              Gender
                                  .male
                          ? l10n.male
                          : l10n
                              .female,
                    ),
                    trailing: Icon(
                      p.clothes
                              .isEmpty
                          ? Icons
                              .warning
                          : Icons
                              .check_circle,
                      color:
                          p.clothes
                                  .isEmpty
                              ? Colors
                                  .orange
                              : Colors
                                  .green,
                    ),
                    onTap: () =>
                        _editClothes(
                      p,
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed:
                  _canContinue
                      ? () {
                          Navigator.of(
                                  context)
                              .push(
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      PartySetupDifficultyScreen(
                                players:
                                    _players,
                              ),
                            ),
                          );
                        }
                      : null,
              child: Text(
                l10n.continueText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}