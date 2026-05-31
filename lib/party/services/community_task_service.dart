import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/community_task.dart';

class CommunityTaskService {
  static final _firestore =
      FirebaseFirestore.instance;

  static final _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _tasks =>
          _firestore.collection(
            'community_tasks',
          );

  static Future<void> uploadTask({
    required String text,
    required String gender,
    required int difficulty,
    required bool anonymous,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final task = CommunityTask(
      id: '',
      text: text,
      gender: gender,
      difficulty: difficulty,
      authorUid: user.uid,
      anonymous: anonymous,
      likes: 0,
      createdAt: DateTime.now(),
    );

    await _tasks.add(
      task.toMap(),
    );
  }

  static Stream<List<CommunityTask>>
      latestTasks() {
    return _tasks
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                CommunityTask
                    .fromFirestore,
              )
              .toList(),
        );
  }

  static Stream<List<CommunityTask>>
      topTasks() {
    return _tasks
        .orderBy(
          'likes',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                CommunityTask
                    .fromFirestore,
              )
              .toList(),
        );
  }

  static Future<void> likeTask(
    String taskId,
  ) async {
    await _tasks.doc(taskId).update(
      {
        'likes':
            FieldValue.increment(1),
      },
    );
  }

  static Future<void> reportTask(
    String taskId,
  ) async {
    final user =
        _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('reported_tasks')
        .add({
      'taskId': taskId,
      'reporterUid': user.uid,
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }
}