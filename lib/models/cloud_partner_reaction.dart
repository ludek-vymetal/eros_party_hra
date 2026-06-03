import 'package:cloud_firestore/cloud_firestore.dart';

class CloudPartnerReaction {
  final String id;

  final String senderUid;
  final String receiverUid;

  final String scenarioId;

  final String message;

  final DateTime createdAt;

  CloudPartnerReaction({
    required this.id,
    required this.senderUid,
    required this.receiverUid,
    required this.scenarioId,
    required this.message,
    required this.createdAt,
  });

  factory CloudPartnerReaction.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return CloudPartnerReaction(
      id: doc.id,
      senderUid: data['senderUid'] ?? '',
      receiverUid: data['receiverUid'] ?? '',
      scenarioId: data['scenarioId'] ?? '',
      message: data['message'] ?? '',
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
      'scenarioId': scenarioId,
      'message': message,
      'createdAt':
          FieldValue.serverTimestamp(),
    };
  }

  String get datumFormatted =>
      '${createdAt.day}.${createdAt.month}.${createdAt.year} '
      '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
}