import '../models/player.dart';
import 'package:flutter/material.dart';

class RescueController {
  final Map<String, int>
      _playerNakedRounds = {};

  bool _rescueActive = false;

  bool onTurn(
    List<PartyPlayer> players,
    PartyPlayer currentPlayer,
  ) {
    // 1️⃣ Reset hráčů,
    // kteří už nejsou nazí
    for (final p in players) {
      if (!p.isNaked) {
        _playerNakedRounds[p.name] = 0;
      }
    }

    // 2️⃣ Přičtení kola
    // aktuálnímu nahému hráči
    if (currentPlayer.isNaked) {
      final currentCount =
          _playerNakedRounds[
                  currentPlayer.name] ??
              0;

      _playerNakedRounds[
              currentPlayer.name] =
          currentCount + 1;

      // DEBUG
      debugPrint(
        '🔥 ${currentPlayer.name} '
        'je nahý '
        '${currentCount + 1} kol',
      );
    }

    // 3️⃣ Kontrola 5 kol
    final roundsForPlayer =
        _playerNakedRounds[
                currentPlayer.name] ??
            0;

    if (roundsForPlayer >= 5 &&
        !_rescueActive) {
      _rescueActive = true;

      // reset počítadla
      _playerNakedRounds[
              currentPlayer.name] =
          0;

      return true;
    }

    return false;
  }

  bool resolveVoting(
    List<bool> votes,
  ) {
    if (votes.isEmpty) {
      return false;
    }

    final yesVotes =
        votes.where((v) => v).length;

    return yesVotes >
        votes.length / 2;
  }

  void finishRescue() {
    _rescueActive = false;
  }
}