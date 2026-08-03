import 'package:cloud_firestore/cloud_firestore.dart';

class CloudPartnerScenario {
  final String id;

  /// ❤️ Vztah, ke kterému scénář patří
  final String relationshipId;

  final String senderUid;
  final String receiverUid;

  /// ❤️ stejné pro všechna opakování jednoho scénáře
  final String parentScenarioId;

  final String nazev;
  final String text;

  /// received
  /// postponed
  /// completed
  /// rejected
  final String status;

  final DateTime createdAt;

  CloudPartnerScenario({
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
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return CloudPartnerScenario(
      id: doc.id,

      relationshipId:
          data['relationshipId'] ?? '',

      senderUid: data['senderUid'] ?? '',
      receiverUid: data['receiverUid'] ?? '',

      parentScenarioId:
          data['parentScenarioId'] ?? doc.id,

      nazev: data['nazev'] ?? '',
      text: data['text'] ?? '',

      status:
          data['status'] ?? 'received',

      createdAt:
          (data['createdAt'] as Timestamp?)
                  ?.toDate() ??
              DateTime.now(),
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

      'createdAt':
          FieldValue.serverTimestamp(),
    };
  }
}