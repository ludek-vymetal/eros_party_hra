import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cloud_partner_reaction.dart';

class CloudPartnerReactionService {
  static final _firestore =
      FirebaseFirestore.instance;

  static final _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _reactions =>
          _firestore.collection(
            'partner_reactions',
          );

  static Future<void> sendReaction({
    required String receiverUid,
    required String scenarioId,
    required String message,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final reaction =
        CloudPartnerReaction(
      id: '',
      senderUid: user.uid,
      receiverUid: receiverUid,
      scenarioId: scenarioId,
      message: message,
      createdAt: DateTime.now(),
    );

    await _reactions.add(
      reaction.toMap(),
    );
  }

  static Stream<List<CloudPartnerReaction>>
      incomingReactions(
    String myUid,
  ) {
    return _reactions
        .where(
          'receiverUid',
          isEqualTo: myUid,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                CloudPartnerReaction
                    .fromFirestore,
              )
              .toList(),
        );
  }
}