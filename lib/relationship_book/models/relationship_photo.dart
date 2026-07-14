class RelationshipPhoto {
  final String id;
  final String chapterId;
  final String authorId;
  final String storagePath;
  final String downloadUrl;
  final DateTime createdAt;

  const RelationshipPhoto({
    required this.id,
    required this.chapterId,
    required this.authorId,
    required this.storagePath,
    required this.downloadUrl,
    required this.createdAt,
  });

  RelationshipPhoto copyWith({
    String? id,
    String? chapterId,
    String? authorId,
    String? storagePath,
    String? downloadUrl,
    DateTime? createdAt,
  }) {
    return RelationshipPhoto(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      authorId: authorId ?? this.authorId,
      storagePath: storagePath ?? this.storagePath,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'authorId': authorId,
      'storagePath': storagePath,
      'downloadUrl': downloadUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RelationshipPhoto.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelationshipPhoto(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      authorId: json['authorId'] as String,
      storagePath: json['storagePath'] as String,
      downloadUrl: json['downloadUrl'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
    );
  }
}