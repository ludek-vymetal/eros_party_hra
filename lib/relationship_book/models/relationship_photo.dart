class RelationshipPhoto {
  final String id;
  final String chapterId;
  final String authorId;
  final String storagePath;
  final String downloadUrl;
  final String description;
  final DateTime createdAt;
 

  /// zda je fotografie sdílená s partnerem
  final bool sharedWithPartner;

  const RelationshipPhoto({
    required this.id,
    required this.chapterId,
    required this.authorId,
    required this.storagePath,
    required this.downloadUrl,
    required this.description,
    required this.createdAt,
    this.sharedWithPartner = false,
  });

  RelationshipPhoto copyWith({
    String? id,
    String? chapterId,
    String? authorId,
    String? storagePath,
    String? downloadUrl,
    String? description,
    DateTime? createdAt,
    bool? sharedWithPartner,
  }) {
    return RelationshipPhoto(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      authorId: authorId ?? this.authorId,
      storagePath: storagePath ?? this.storagePath,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      sharedWithPartner:
          sharedWithPartner ?? this.sharedWithPartner,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'authorId': authorId,
      'storagePath': storagePath,
      'downloadUrl': downloadUrl,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'sharedWithPartner': sharedWithPartner,
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
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      sharedWithPartner:
          json['sharedWithPartner'] as bool? ?? false,
    );
  }
}