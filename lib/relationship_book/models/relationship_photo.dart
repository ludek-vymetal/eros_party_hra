class RelationshipPhoto {
  final String id;
  final String chapterId;
  final String path;
  final DateTime createdAt;

  const RelationshipPhoto({
    required this.id,
    required this.chapterId,
    required this.path,
    required this.createdAt,
  });

  RelationshipPhoto copyWith({
    String? id,
    String? chapterId,
    String? path,
    DateTime? createdAt,
  }) {
    return RelationshipPhoto(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}