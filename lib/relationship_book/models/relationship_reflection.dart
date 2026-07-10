class RelationshipReflection {
  final String id;

  final String chapterId;

  final String authorId;

  final String text;

  final DateTime createdAt;

  final DateTime updatedAt;

  const RelationshipReflection({
    required this.id,
    required this.chapterId,
    required this.authorId,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'authorId': authorId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RelationshipReflection.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelationshipReflection(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      authorId: json['authorId'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
    );
  }

  RelationshipReflection copyWith({
    String? id,
    String? chapterId,
    String? authorId,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RelationshipReflection(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      authorId: authorId ?? this.authorId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}