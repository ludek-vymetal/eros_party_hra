/// Jeden konkrétní prožitek v rámci kapitoly.
///
/// Jedna kapitola může obsahovat libovolný počet prožitků.
/// Například:
///
/// - první splnění scénáře
/// - druhé splnění po roce
/// - další společný návrat
class RelationshipMoment {
  final String id;

  final DateTime createdAt;

  final DateTime updatedAt;

  const RelationshipMoment({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RelationshipMoment.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelationshipMoment(
      id: json['id'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
    );
  }
}