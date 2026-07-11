enum WhisperCategory {
  chapter,
  surprise,
  excitement,
  adventure,
  courage,
  challenge,
  completion,
}

class ErosWhisper {
  final int id;
  final WhisperCategory category;
  final String cs;
  final String en;

  const ErosWhisper({
    required this.id,
    required this.category,
    required this.cs,
    required this.en,
  });
}