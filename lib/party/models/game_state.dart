import 'player.dart';

class PartyGameState {
  final List<PartyPlayer> players;
  final int difficulty;
  int currentIndex;

  PartyGameState({
    required this.players,
    required this.difficulty,
    this.currentIndex = 0,
  });

  PartyPlayer get currentPlayer => players[currentIndex];

  void nextPlayer() {
    currentIndex = (currentIndex + 1) % players.length;
  }

  // 🔽 SERIALIZACE
  Map<String, dynamic> toJson() {
    return {
      'difficulty': difficulty,
      'currentIndex': currentIndex,
      'players': players.map((p) => p.toJson()).toList(),
    };
  }

  factory PartyGameState.fromJson(Map<String, dynamic> json) {
    return PartyGameState(
      difficulty: json['difficulty'],
      currentIndex: json['currentIndex'],
      players: (json['players'] as List)
          .map((p) => PartyPlayer.fromJson(p))
          .toList(),
    );
  }
}
