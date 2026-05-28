import '../models/game_state.dart';

import 'task_bank.dart';

class TurnResult {
  final String taskText;
  final bool canDress;
  final String? removedClothing;
  final bool isLastClothing;

  TurnResult({
    required this.taskText,
    this.canDress = false,
    this.removedClothing,
    this.isLastClothing = false,
  });
}

class PartyGameEngine {
  final PartyGameState state;
  final TaskBank taskBank;

  PartyGameEngine({
    required this.state,
    required this.taskBank,
  });

  TurnResult startTurn() {
    final player = state.currentPlayer;
    final task = taskBank.getRandomTask(
      player.gender,
      state.difficulty,
    );
    return TurnResult(taskText: task);
  }

  TurnResult completeTask() {
    final player = state.currentPlayer;
    player.incrementCompleted();

    // ODRENA: Pokud splní 3 úkoly a je nahý
    if (player.completed >= 3 && player.isNaked) {
      player.resetCompleted();
      // DŮLEŽITÉ: canDress signalizuje UI, že má dát 1 kus oblečení
      return TurnResult(
        taskText: 'Úžasné! 3 úkoly v řadě!',
        canDress: true,
      );
    }

    state.nextPlayer();
    return startTurn();
  }

  TurnResult refuseTask() {
    final player = state.currentPlayer;
    player.resetCompleted();
    final wasLast = player.clothes.length == 1;
    final removed = player.removeRandomClothing();

    return TurnResult(
      taskText: '',
      removedClothing: removed,
      isLastClothing: wasLast,
    );
  }

  void nextPlayer() {
    state.nextPlayer();
  }

  // Přidán parametr shouldNext, aby UI mohlo řídit posun tahu
  void dressPlayer(String clothing, {bool shouldNext = true}) {
    final player = state.currentPlayer;
    player.addClothing(clothing);
    if (shouldNext) state.nextPlayer();
  }
}