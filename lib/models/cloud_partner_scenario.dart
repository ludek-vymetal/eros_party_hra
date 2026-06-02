import 'package:cloud_firestore/cloud_firestore.dart';

class CloudPartnerScenario {
  final String id;
  final String senderUid;
  final String receiverUid;

  final String nazev;
  final String text;

  final DateTime createdAt;

  CloudPartnerScenario({
    required this.id,
    required this.senderUid,
    required this.receiverUid,
    required this.nazev,
    required this.text,
    required this.createdAt,
  });

  factory CloudPartnerScenario.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return CloudPartnerScenario(
      id: doc.id,
      senderUid: data['senderUid'] ?? '',
      receiverUid: data['receiverUid'] ?? '',
      nazev: data['nazev'] ?? '',
      text: data['text'] ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)
                  ?.toDate() ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'nazev': nazev,
      'text': text,
      'createdAt':
          FieldValue.serverTimestamp(),
    };
  }
}