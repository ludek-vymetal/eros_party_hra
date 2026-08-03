import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cloud_partner_reaction.dart';
import 'relationship_service.dart';

class CloudPartnerReactionService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _reactions =>
          _firestore.collection(
            'partner_reactions',
          );

  static Future<String?> sendReaction({
    required String receiverUid,
    required String scenarioName,
    required String scenarioId,
    required String message,
    required bool completed,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final relationship =
        await RelationshipService.getActiveRelationship();

    if (relationship == null) {
      throw Exception(
        'No active relationship.',
      );
    }

    final correlationId =
        '${DateTime.now().millisecondsSinceEpoch}_${user.uid}';

    final reaction = CloudPartnerReaction(
      id: '',
      relationshipId: relationship.id,
      correlationId: correlationId,
      senderUid: user.uid,
      receiverUid: receiverUid,
      scenarioId: scenarioId,
      scenarioName: scenarioName,
      message: message,
      completed: completed,
      proofSent: false,
      proofAccepted: false,
      createdAt: DateTime.now(),
    );

    final doc = await _reactions.add(
      reaction.toMap(),
    );

    return doc.id;
  }

  static Future<void> markProofSent(
    String correlationId,
  ) async {
    final snapshot = await _reactions
        .where(
          'correlationId',
          isEqualTo: correlationId,
        )
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(
        doc.reference,
        {
          'proofSent': true,
        },
      );
    }

    await batch.commit();
  }

  static Future<void> acceptProof(
    String correlationId,
  ) async {
    final snapshot = await _reactions
        .where(
          'correlationId',
          isEqualTo: correlationId,
        )
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(
        doc.reference,
        {
          'proofAccepted': true,
        },
      );
    }

    await batch.commit();
  }

  static Future<void> deleteReaction(
    String correlationId,
  ) async {
    final snapshot = await _reactions
        .where(
          'correlationId',
          isEqualTo: correlationId,
        )
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(
        doc.reference,
      );
    }

    await batch.commit();
  }

  static Stream<List<CloudPartnerReaction>>
      incomingReactions(
    String relationshipId,
  ) {
    return _reactions
        .where(
          'relationshipId',
          isEqualTo: relationshipId,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                CloudPartnerReaction.fromFirestore,
              )
              .toList(),
        );
  }
}