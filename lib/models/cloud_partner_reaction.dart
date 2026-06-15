import 'package:cloud_firestore/cloud_firestore.dart';

class CloudPartnerReaction {
  final String id;
  final String correlationId; // Klíčové pro propojení obou stran

  final String senderUid;
  final String receiverUid;

  final String scenarioId;
  final String scenarioName;
  final String message;

  // ✅ splněno / nesplněno
  final bool completed;

  // 📷 důkaz odeslán přes WhatsApp
  final bool proofSent;

  // ✅ partner uznal důkaz
  final bool proofAccepted;

  final DateTime createdAt;

  CloudPartnerReaction({
    required this.id,
    required this.correlationId,
    required this.senderUid,
    required this.receiverUid,
    required this.scenarioId,
    required this.scenarioName,
    required this.message,
    required this.completed,
    required this.proofSent,
    required this.proofAccepted,
    required this.createdAt,
  });

  factory CloudPartnerReaction.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return CloudPartnerReaction(
      id: doc.id,
      correlationId: data['correlationId'] ?? '',
      senderUid: data['senderUid'] ?? '',
      receiverUid: data['receiverUid'] ?? '',
      scenarioId: data['scenarioId'] ?? '',
      scenarioName: data['scenarioName'] ?? '',
      message: data['message'] ?? '',
      completed: data['completed'] ?? false,
      proofSent: data['proofSent'] ?? false,
      proofAccepted: data['proofAccepted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'correlationId': correlationId,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'scenarioId': scenarioId,
      'scenarioName': scenarioName,
      'message': message,
      'completed': completed,
      'proofSent': proofSent,
      'proofAccepted': proofAccepted,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  String get datumFormatted =>
      '${createdAt.day}.${createdAt.month}.${createdAt.year} '
      '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
}