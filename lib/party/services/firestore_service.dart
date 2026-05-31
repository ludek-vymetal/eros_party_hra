import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/community_task.dart';

class FirestoreService {
  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  static Future<void> uploadTask(
    CommunityTask task,
  ) async {
    await _db
        .collection('community_tasks')
        .add(task.toMap());
  }

  static Future<List<CommunityTask>>
      loadCommunityTasks() async {
    final snapshot =
        await _db
            .collection('community_tasks')
            .get();

    return snapshot.docs
        .map(
          (doc) =>
              CommunityTask.fromFirestore(doc),
        )
        .toList();
  }

  static String get currentUid =>
      FirebaseAuth
          .instance
          .currentUser!
          .uid;
}