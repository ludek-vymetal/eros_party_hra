class Relationship {
  final String id;
  final String user1Uid;
  final String user2Uid;
  final DateTime createdAt;

  const Relationship({
    required this.id,
    required this.user1Uid,
    required this.user2Uid,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user1Uid': user1Uid,
      'user2Uid': user2Uid,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Relationship.fromFirestore(
    String id,
    Map<String, dynamic> json,
  ) {
    return Relationship(
      id: id,
      user1Uid: json['user1Uid'] as String,
      user2Uid: json['user2Uid'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
    );
  }
}