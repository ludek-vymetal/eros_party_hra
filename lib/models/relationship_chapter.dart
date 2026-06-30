class RelationshipChapter {
  final String id;

  final DateTime createdAt;

  final String scenarioRecordId;

  final String chapterTitle;

  final String introduction;

  final String authorReflection;

  final String partnerReflection;

  final bool favorite;

  const RelationshipChapter({
    required this.id,
    required this.createdAt,
    required this.scenarioRecordId,
    required this.chapterTitle,
    this.introduction = '',
    this.authorReflection = '',
    this.partnerReflection = '',
    this.favorite = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'scenarioRecordId': scenarioRecordId,
        'chapterTitle': chapterTitle,
        'introduction': introduction,
        'authorReflection': authorReflection,
        'partnerReflection': partnerReflection,
        'favorite': favorite,
      };

  factory RelationshipChapter.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelationshipChapter(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      scenarioRecordId: json['scenarioRecordId'],
      chapterTitle: json['chapterTitle'] ?? '',
      introduction: json['introduction'] ?? '',
      authorReflection: json['authorReflection'] ?? '',
      partnerReflection: json['partnerReflection'] ?? '',
      favorite: json['favorite'] ?? false,
    );
  }

  RelationshipChapter copyWith({
    String? chapterTitle,
    String? introduction,
    String? authorReflection,
    String? partnerReflection,
    bool? favorite,
  }) {
    return RelationshipChapter(
      id: id,
      createdAt: createdAt,
      scenarioRecordId: scenarioRecordId,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      introduction: introduction ?? this.introduction,
      authorReflection:
          authorReflection ?? this.authorReflection,
      partnerReflection:
          partnerReflection ?? this.partnerReflection,
      favorite: favorite ?? this.favorite,
    );
  }
}