import 'scenario_record.dart';

class RelationshipChapter {
  final String id;

  final DateTime createdAt;

  final bool favorite;

  final String? imagePath;

  final ScenarioRecord record;

  final String chapterTitle;

  final String introduction;

  final String authorReflection;

  final String partnerReflection;

  

  const RelationshipChapter({
    required this.id,
    required this.createdAt,
    required this.record,
    required this.chapterTitle,
    this.introduction = '',
    this.authorReflection = '',
    this.partnerReflection = '',
    this.favorite = false,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'record': record.toJson(),
        'chapterTitle': chapterTitle,
        'introduction': introduction,
        'authorReflection': authorReflection,
        'partnerReflection': partnerReflection,
        'favorite': favorite,
        'imagePath': imagePath,
      };

  factory RelationshipChapter.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelationshipChapter(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      record: ScenarioRecord.fromJson(
        Map<String, dynamic>.from(
          json['record'],
        ),
      ),
      chapterTitle: json['chapterTitle'] ?? '',
      introduction: json['introduction'] ?? '',
      authorReflection: json['authorReflection'] ?? '',
      partnerReflection: json['partnerReflection'] ?? '',
      favorite: json['favorite'] ?? false,
      imagePath: json['imagePath'],
    );
  }

  RelationshipChapter copyWith({
    String? chapterTitle,
    String? introduction,
    String? authorReflection,
    String? partnerReflection,
    bool? favorite,
    String? imagePath,
  }) {
    return RelationshipChapter(
      id: id,
      createdAt: createdAt,
      record: record,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      introduction: introduction ?? this.introduction,
      authorReflection:
          authorReflection ?? this.authorReflection,
      partnerReflection:
          partnerReflection ?? this.partnerReflection,
      favorite: favorite ?? this.favorite,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}