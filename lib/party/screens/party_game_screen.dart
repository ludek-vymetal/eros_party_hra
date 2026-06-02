import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

import '../widgets/last_clothing_overlay.dart';
import '../rescue/rescue_controller.dart';
import '../rescue/rescue_overlay.dart';

import '../services/party_game_engine.dart';
import '../services/party_game_persistence.dart';

class PartyGameScreen extends StatefulWidget {
  final PartyGameEngine engine;

  const PartyGameScreen({
    super.key,
    required this.engine,
  });

  @override
  State<PartyGameScreen> createState() =>
      _PartyGameScreenState();
}

class _PartyGameScreenState
    extends State<PartyGameScreen> {
  late TurnResult _currentTurn;

  final RescueController
      _rescueController =
      RescueController();

  bool _waitingAfterRefuse =
      false;

  bool _showLastClothing =
      false;

  String? _lastClothing;

  bool _isRescueActive = false;

  int _currentVoterIndex = 0;

  List<bool> _rescueVotes = [];

  List<dynamic> _voters = [];

  @override
  void initState() {
    super.initState();

    _currentTurn =
        widget.engine.startTurn();
  }

  void _processTurnResult(
    TurnResult result,
  ) {
    setState(() {
      _currentTurn = result;
      _waitingAfterRefuse = false;
    });

    if (result.canDress) {
      _showDressDialog(
        isDouble: false,
      );

      return;
    }

    final shouldStartRescue =
        _rescueController.onTurn(
      widget.engine.state.players,
      widget.engine.state.currentPlayer,
    );

    if (shouldStartRescue) {
      _startRescueVoting();
    }
  }

  void _onComplete() {
    final result =
        widget.engine.completeTask();

    _processTurnResult(result);
  }

  void _onRefuse() {
    final result =
        widget.engine.refuseTask();

    if (result.isLastClothing &&
        result.removedClothing !=
            null) {
      setState(() {
        _showLastClothing = true;
        _lastClothing =
            result.removedClothing;
      });

      return;
    }

    setState(() {
      _currentTurn = result;
      _waitingAfterRefuse = true;
    });

    final shouldStartRescue =
        _rescueController.onTurn(
      widget.engine.state.players,
      widget.engine.state.currentPlayer,
    );

    if (shouldStartRescue) {
      _startRescueVoting();
    }
  }

  void _onNextAfterRefuse() {
    widget.engine.nextPlayer();

    setState(() {
      _currentTurn =
          widget.engine.startTurn();

      _waitingAfterRefuse = false;
    });
  }

  void _startRescueVoting() {
    _voters =
        widget.engine.state.players
            .toList();

    setState(() {
      _isRescueActive = true;
      _currentVoterIndex = 0;
      _rescueVotes = [];
    });
  }

  void _handleVote(bool vote) {
    setState(() {
      _rescueVotes.add(vote);

      if (_rescueVotes.length <
          _voters.length) {
        _currentVoterIndex++;
      } else {
        _isRescueActive = false;
        _finishRescueProcess();
      }
    });
  }

  void _finishRescueProcess() {
    final l10n =
        AppLocalizations.of(context);

    final success =
        _rescueController
            .resolveVoting(
      _rescueVotes,
    );

    _rescueController
        .finishRescue();

    if (success) {
      _showDressDialog(
        isDouble: true,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            l10n.rescueApproved,
          ),
          backgroundColor:
              Colors.green,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor:
              const Color(
            0xFF1A0F14,
          ),
          title: Text(
            l10n.rescueDenied,
            style: const TextStyle(
              color:
                  Colors.redAccent,
            ),
          ),
          content: Text(
            l10n.rescueDeniedText,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: Text(
                l10n.ok,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showDressDialog({
    bool isDouble = false,
  }) {
    final l10n =
        AppLocalizations.of(context);

    int remaining =
        isDouble ? 2 : 1;

    void showSingleDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text(
            remaining > 1
                ? l10n.rescueSelectFirst
                : l10n.chooseClothing,
          ),
          content:
              SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  l10n.selectClothing,
                  style:
                      const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                for (final clothing
                    in [
                  l10n.boxers,
                  l10n.bra,
                  l10n.pants,
                  l10n.shoes,
                  l10n.tshirt,
                  l10n.hoodie,
                  l10n.socks,
                  l10n.panties,
                  l10n.sweater,
                ])
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    child:
                        ElevatedButton(
                      onPressed: () {
                        remaining--;

                        widget.engine
                            .dressPlayer(
                          clothing,
                          shouldNext:
                              remaining ==
                                  0,
                        );

                        Navigator.of(
                                context)
                            .pop();

                        if (remaining >
                            0) {
                          showSingleDialog();
                        } else {
                          setState(() {
                            _currentTurn =
                                widget
                                    .engine
                                    .startTurn();
                          });
                        }
                      },
                      child: Text(
                        clothing,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    showSingleDialog();
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context);

    final player =
        widget.engine.state.currentPlayer;

    final nakedPlayers = widget
        .engine.state.players
        .where((p) => p.isNaked)
        .toList();

    return Scaffold(
      backgroundColor:
          const Color(0xFF0F0A0D),

      appBar: AppBar(
        title: Text(
          l10n.partyGame,
        ),
        backgroundColor:
            const Color(
          0xFF1A0F14,
        ),
      ),

      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 520,
              ),
              child: Container(
                padding:
                    const EdgeInsets.all(
                  32,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFF1A0F14,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                  border:
                      player.isNaked
                          ? Border.all(
                              color:
                                  Colors
                                      .redAccent,
                              width: 2,
                            )
                          : null,
                ),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Text(
                      player.isNaked
                          ? '🔥 ${l10n.currentTurn}: ${player.name} (${l10n.naked})'
                          : '${l10n.currentTurn}: ${player.name}',
                      style:
                          TextStyle(
                        fontSize: 26,
                        fontWeight:
                            FontWeight
                                .bold,
                        color:
                            player
                                    .isNaked
                                ? Colors
                                    .redAccent
                                : Colors
                                    .white,
                      ),
                    ),

                    const SizedBox(
                      height: 32,
                    ),

                    if (_currentTurn
                            .removedClothing !=
                        null) ...[
                      Text(
                        l10n.youRemove,
                        style:
                            const TextStyle(
                          fontSize: 18,
                          color: Colors
                              .white70,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        _currentTurn
                            .removedClothing!,
                        style:
                            const TextStyle(
                          fontSize: 32,
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              Colors
                                  .redAccent,
                        ),
                      ),
                    ] else ...[
                      Text(
                        _currentTurn
                            .taskText,
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            const TextStyle(
                          fontSize: 26,
                          color:
                              Colors
                                  .white,
                        ),
                      ),
                    ],

                    const SizedBox(
                      height: 40,
                    ),

                    if (_waitingAfterRefuse)
                      ElevatedButton(
                        onPressed:
                            _onNextAfterRefuse,
                        child: Text(
                          l10n.continueText,
                        ),
                      )
                    else ...[
                      ElevatedButton(
                        onPressed:
                            _onComplete,
                        child: Text(
                          l10n.complete,
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      OutlinedButton(
                        onPressed:
                            _onRefuse,
                        child: Text(
                          l10n.refuse,
                        ),
                      ),
                    ],

                    const SizedBox(
                      height: 32,
                    ),

                    const Divider(),

                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.save,
                      ),
                      label: Text(
                        l10n.saveAndExit,
                      ),
                      onPressed:
                          () async {
                        final navigator =
                            Navigator.of(
                                context);

                        await PartyGamePersistence
                            .save(
                          widget.engine
                              .state,
                        );

                        if (!mounted) {
                          return;
                        }

                        navigator.popUntil(
                          (r) =>
                              r.isFirst,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (nakedPlayers
              .isNotEmpty)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.all(
                  14,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors.black
                      .withValues(
                    alpha: 0.75,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  border: Border.all(
                    color: Colors
                        .redAccent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n
                          .fullyNakedPlayers,
                      style:
                          const TextStyle(
                        color: Colors
                            .redAccent,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    for (final p
                        in nakedPlayers)
                      Text(
                        p.name,
                        style:
                            const TextStyle(
                          fontSize: 22,
                          color:
                              Colors
                                  .white,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),

          if (_showLastClothing &&
              _lastClothing != null)
            LastClothingOverlay(
              playerName:
                  player.name,
              clothing:
                  _lastClothing!,
              onFinish: () {
                widget.engine
                    .nextPlayer();

                setState(() {
                  _currentTurn =
                      widget.engine
                          .startTurn();

                  _showLastClothing =
                      false;

                  _waitingAfterRefuse =
                      false;
                });
              },
            ),

          if (_isRescueActive)
            RescueOverlay(
              voterName:
                  _voters[
                          _currentVoterIndex]
                      .name,
              rescuedName:
                  player.name,
              onYes: () =>
                  _handleVote(true),
              onNo: () =>
                  _handleVote(false),
            ),
        ],
      ),
    );
  }
}