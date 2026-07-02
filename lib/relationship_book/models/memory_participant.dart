/// Reprezentuje jednoho účastníka konkrétní vzpomínky.
///
/// Nejedná se o uživatele aplikace,
/// ale o jeho pohled na jednu konkrétní kapitolu.
///
/// Díky tomu zůstává historie zachována,
/// i když si uživatel později změní profil.
class MemoryParticipant {
  final String participantUid;
  final String nickname;
  final String feeling;
  final String emotion;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MemoryParticipant({
    required this.participantUid,
    required this.nickname,
    required this.feeling,
    required this.emotion,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'participantUid': participantUid,
      'nickname': nickname,
      'feeling': feeling,
      'emotion': emotion,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MemoryParticipant.fromJson(
    Map<String, dynamic> json,
  ) {
    return MemoryParticipant(
      participantUid: json['participantUid'],
      nickname: json['nickname'],
      feeling: json['feeling'],
      emotion: json['emotion'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}