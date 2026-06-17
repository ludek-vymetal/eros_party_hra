import 'package:cloud_firestore/cloud_firestore.dart';

class CloudPartnerScenario {
  final String id;
  final String senderUid;
  final String receiverUid;

  // ❤️ stejné pro všechna opakování jednoho scénáře
  final String parentScenarioId;

  final String nazev;
  final String text;

  // 📥 received
  // ⏳ postponed
  // ✅ completed
  // ❌ rejected
  final String status;

  final DateTime createdAt;

  CloudPartnerScenario({
    required this.id,
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

    // Pomocná proměnná pro bezpečné načtení data
    DateTime createdAt;
    final rawCreatedAt = data['createdAt'];

    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is DateTime) {
      createdAt = rawCreatedAt;
    } else {
      createdAt = DateTime.now();
    }

    return CloudPartnerScenario(
      id: doc.id,
      senderUid: data['senderUid'] ?? '',
      receiverUid: data['receiverUid'] ?? '',
      parentScenarioId: data['parentScenarioId'] ?? doc.id,
      nazev: data['nazev'] ?? '',
      text: data['text'] ?? '',
      status: data['status'] ?? 'received',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'receiverUid': receiverUid,

      'parentScenarioId': parentScenarioId,

      'nazev': nazev,
      'text': text,

      'status': 'received',

      'createdAt':
          FieldValue.serverTimestamp(),
    };
  }
}