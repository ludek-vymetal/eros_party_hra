import 'package:cloud_firestore/cloud_firestore.dart';

class CloudRelationshipChapter {
  final String id;
  final String ownerUid;
  final String partnerUid;

  final String parentScenarioId;

  final String chapterTitle;
  final String introduction;

  final String scenarioTitle;
  final String scenarioText;

  final String reactionStatus;
  final String reactionMessage;

  final bool favorite;

  final String? imagePath;

  final DateTime createdAt;

  const CloudRelationshipChapter({
    required this.id,
    required this.ownerUid,
    required this.partnerUid,
    required this.parentScenarioId,
    required this.chapterTitle,
    required this.introduction,
    required this.scenarioTitle,
    required this.scenarioText,
    required this.reactionStatus,
    required this.reactionMessage,
    required this.favorite,
    this.imagePath,
    required this.createdAt,
  });

  factory CloudRelationshipChapter.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return CloudRelationshipChapter(
      id: doc.id,
      ownerUid: data['ownerUid'] ?? '',
      partnerUid: data['partnerUid'] ?? '',
      parentScenarioId: data['parentScenarioId'] ?? '',
      chapterTitle: data['chapterTitle'] ?? '',
      introduction: data['introduction'] ?? '',
      scenarioTitle: data['scenarioTitle'] ?? '',
      scenarioText: data['scenarioText'] ?? '',
      reactionStatus: data['reactionStatus'] ?? '',
      reactionMessage: data['reactionMessage'] ?? '',
      favorite: data['favorite'] ?? false,
      imagePath: data['imagePath'],
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerUid': ownerUid,
      'partnerUid': partnerUid,
      'parentScenarioId': parentScenarioId,
      'chapterTitle': chapterTitle,
      'introduction': introduction,
      'scenarioTitle': scenarioTitle,
      'scenarioText': scenarioText,
      'reactionStatus': reactionStatus,
      'reactionMessage': reactionMessage,
      'favorite': favorite,
      'imagePath': imagePath,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}