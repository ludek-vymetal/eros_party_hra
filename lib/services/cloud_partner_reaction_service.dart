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

  static Future<String?> sendReaction({
    required String receiverUid,
    required String scenarioId,
    required String message,
    required bool completed,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final reaction =
        CloudPartnerReaction(
      id: '',
      senderUid: user.uid,
      receiverUid: receiverUid,
      scenarioId: scenarioId,
      message: message,
      completed: completed,
      proofSent: false,
      proofAccepted: false,
      createdAt: DateTime.now(),
    );

    final doc =
        await _reactions.add(
      reaction.toMap(),
    );

    return doc.id;
  }

  static Future<void> markProofSent(
    String reactionId,
  ) async {
    await _reactions
        .doc(reactionId)
        .update({
      'proofSent': true,
    });
  }

  static Future<void> acceptProof(
    String reactionId,
  ) async {
    await _reactions
        .doc(reactionId)
        .update({
      'proofAccepted': true,
    });
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