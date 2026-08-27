import 'package:cloud_firestore/cloud_firestore.dart';

class CloudPartnerScenario {
  final String id;
  final String relationshipId;
  final String senderUid;
  final String receiverUid;
  final String parentScenarioId;
  final String nazev;
  final String text;
  final String status;
  final DateTime createdAt;

  const CloudPartnerScenario({
    required this.id,
    required this.relationshipId,
    required this.senderUid,
    required this.receiverUid,
    required this.parentScenarioId,
    required this.nazev,
    required this.text,
    required this.status,
    required this.createdAt,
  });

  factory CloudPartnerScenario.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    final createdAtValue = data['createdAt'];

    DateTime createdAt;

    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    } else if (createdAtValue is DateTime) {
      createdAt = createdAtValue;
    } else {
      createdAt = DateTime.now();
    }

    return CloudPartnerScenario(
      id: doc.id,
      relationshipId:
          data['relationshipId'] as String? ?? '',
      senderUid:
          data['senderUid'] as String? ?? '',
      receiverUid:
          data['receiverUid'] as String? ?? '',
      parentScenarioId:
          data['parentScenarioId'] as String? ?? '',
      nazev:
          data['nazev'] as String? ?? '',
      text:
          data['text'] as String? ?? '',
      status:
          data['status'] as String? ?? 'received',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'relationshipId': relationshipId,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'parentScenarioId': parentScenarioId,
      'nazev': nazev,
      'text': text,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  CloudPartnerScenario copyWith({
    String? id,
    String? relationshipId,
    String? senderUid,
    String? receiverUid,
    String? parentScenarioId,
    String? nazev,
    String? text,
    String? status,
    DateTime? createdAt,
  }) {
    return CloudPartnerScenario(
      id: id ?? this.id,
      relationshipId:
          relationshipId ?? this.relationshipId,
      senderUid:
          senderUid ?? this.senderUid,
      receiverUid:
          receiverUid ?? this.receiverUid,
      parentScenarioId:
          parentScenarioId ?? this.parentScenarioId,
      nazev: nazev ?? this.nazev,
      text: text ?? this.text,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}