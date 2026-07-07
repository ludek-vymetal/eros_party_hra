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

  /// Pořadí momentu v kapitole.
  final int order;

  /// Datum, kdy se moment skutečně odehrál.
  final DateTime momentDate;

  /// Pocity autora.
  final String authorFeeling;

  /// Pocity partnera.
  final String partnerFeeling;

  final DateTime createdAt;

  final DateTime updatedAt;

  const RelationshipMoment({
    required this.id,
    required this.order,
    required this.momentDate,
    required this.authorFeeling,
    required this.partnerFeeling,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'momentDate': momentDate.toIso8601String(),
      'authorFeeling': authorFeeling,
      'partnerFeeling': partnerFeeling,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RelationshipMoment.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelationshipMoment(
      id: json['id'] as String,
      order: json['order'] as int,
      momentDate: DateTime.parse(
        json['momentDate'] as String,
      ),
      authorFeeling: json['authorFeeling'] as String,
      partnerFeeling: json['partnerFeeling'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
    );
  }
}