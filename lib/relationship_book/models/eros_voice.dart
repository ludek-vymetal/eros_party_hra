enum ErosVoiceCategory {
  chapter,
  challenge,
  photo,
  completion,
  surprise,
  adventure,
  excitement,
}

class ErosVoice {
  final int id;
  final ErosVoiceCategory category;
  final String cs;
  final String en;

  const ErosVoice({
    required this.id,
    required this.category,
    required this.cs,
    required this.en,
  });
}