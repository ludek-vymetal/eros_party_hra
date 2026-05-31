import 'package:cloud_firestore/cloud_firestore.dart';


class CommunityTask {
  final String id;
  final String text;
  final String gender;
  final int difficulty;
  final String authorUid;
  final bool anonymous;
  final int likes;
  final DateTime createdAt;

  const CommunityTask({
    required this.id,
    required this.text,
    required this.gender,
    required this.difficulty,
    required this.authorUid,
    required this.anonymous,
    required this.likes,
    required this.createdAt,
  });

  factory CommunityTask.fromFirestore(
    DocumentSnapshot doc,
  ) {
    final data =
        doc.data() as Map<String, dynamic>;

    return CommunityTask(
      id: doc.id,
      text: data['text'] ?? '',
      gender: data['gender'] ?? 'male',
      difficulty:
          data['difficulty'] ?? 1,
      authorUid:
          data['authorUid'] ?? '',
      anonymous:
          data['anonymous'] ?? false,
      likes: data['likes'] ?? 0,
      createdAt:
          (data['createdAt']
                  as Timestamp?)
              ?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'gender': gender,
      'difficulty': difficulty,
      'authorUid': authorUid,
      'anonymous': anonymous,
      'likes': likes,
      'createdAt':
          FieldValue.serverTimestamp(),
    };
  }
}