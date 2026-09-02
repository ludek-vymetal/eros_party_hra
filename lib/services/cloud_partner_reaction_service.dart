import 'package:flutter/foundation.dart';

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

  // ==========================================================
  // SEND REACTION
  // ==========================================================

  static Future<String?> sendReaction({
    required String receiverUid,
    required String scenarioName,
    required String scenarioId,
    required String message,
    required bool completed,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Uživatel není přihlášen.',
      );
    }

    final relationship =
        await RelationshipService.getActiveRelationship();

    if (relationship == null) {
      throw Exception(
        'Není aktivní vztah.',
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

    debugPrint(
      '========== SEND REACTION ==========',
    );

    debugPrint(
      'SENDER UID = ${user.uid}',
    );

    debugPrint(
      'RECEIVER UID = $receiverUid',
    );

    debugPrint(
      'RELATIONSHIP ID = ${relationship.id}',
    );

    final doc = await _reactions.add(
      reaction.toMap(),
    );

    debugPrint(
      'REACTION SENT',
    );

    debugPrint(
      'REACTION DOC ID = ${doc.id}',
    );

    return doc.id;
  }

  // ==========================================================
  // MARK PROOF SENT
  // ==========================================================

  static Future<void> markProofSent(
    String correlationId,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Uživatel není přihlášen.',
      );
    }

    final relationship =
        await RelationshipService.getActiveRelationship();

    if (relationship == null) {
      throw Exception(
        'Není aktivní vztah.',
      );
    }

    debugPrint(
      '========== MARK PROOF SENT ==========',
    );

    debugPrint(
      'MY UID = ${user.uid}',
    );

    debugPrint(
      'RELATIONSHIP ID = ${relationship.id}',
    );

    debugPrint(
      'CORRELATION ID = $correlationId',
    );

    final snapshot = await _reactions
        .where(
          'relationshipId',
          isEqualTo: relationship.id,
        )
        .where(
          'correlationId',
          isEqualTo: correlationId,
        )
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception(
        'Reakce nebyla nalezena.',
      );
    }

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      // Důkaz může označit pouze odesílatel.
      if (data['senderUid'] != user.uid) {
        throw Exception(
          'Nemáte oprávnění označit důkaz jako odeslaný.',
        );
      }

      batch.update(
        doc.reference,
        {
          'proofSent': true,
        },
      );
    }

    await batch.commit();

    debugPrint(
      '✅ PROOF SENT UPDATED',
    );
  }

  // ==========================================================
  // ACCEPT PROOF
  // ==========================================================

  static Future<void> acceptProof(
    String correlationId,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Uživatel není přihlášen.',
      );
    }

    final relationship =
        await RelationshipService.getActiveRelationship();

    if (relationship == null) {
      throw Exception(
        'Není aktivní vztah.',
      );
    }

    debugPrint(
      '========== ACCEPT PROOF ==========',
    );

    debugPrint(
      'MY UID = ${user.uid}',
    );

    debugPrint(
      'RELATIONSHIP ID = ${relationship.id}',
    );

    debugPrint(
      'CORRELATION ID = $correlationId',
    );

    final snapshot = await _reactions
        .where(
          'relationshipId',
          isEqualTo: relationship.id,
        )
        .where(
          'correlationId',
          isEqualTo: correlationId,
        )
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception(
        'Reakce nebyla nalezena.',
      );
    }

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      // Potvrdit může pouze příjemce.
      if (data['receiverUid'] != user.uid) {
        throw Exception(
          'Nemáte oprávnění potvrdit přijetí důkazu.',
        );
      }

      batch.update(
        doc.reference,
        {
          'proofAccepted': true,
        },
      );
    }

    await batch.commit();

    debugPrint(
      '✅ PROOF ACCEPTED',
    );
  }

  // ==========================================================
  // DELETE REACTION
  // ==========================================================

  static Future<void> deleteReaction(
    String correlationId,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Uživatel není přihlášen.',
      );
    }

    final relationship =
        await RelationshipService.getActiveRelationship();

    if (relationship == null) {
      throw Exception(
        'Není aktivní vztah.',
      );
    }

    final snapshot = await _reactions
        .where(
          'relationshipId',
          isEqualTo: relationship.id,
        )
        .where(
          'correlationId',
          isEqualTo: correlationId,
        )
        .get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final senderUid =
          data['senderUid'];

      final receiverUid =
          data['receiverUid'];

      if (senderUid != user.uid &&
          receiverUid != user.uid) {
        throw Exception(
          'Nemáte oprávnění tuto reakci smazat.',
        );
      }

      batch.delete(
        doc.reference,
      );
    }

    await batch.commit();

    debugPrint(
      'REACTION DELETED',
    );
  }

  // ==========================================================
  // REACTIONS FOR RELATIONSHIP
  // ==========================================================

  static Stream<List<CloudPartnerReaction>>
      incomingReactions(
    String relationshipId,
  ) {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value(
        <CloudPartnerReaction>[],
      );
    }

    debugPrint(
      '========== LISTEN REACTIONS ==========',
    );

    debugPrint(
      'MY UID = ${user.uid}',
    );

    debugPrint(
      'RELATIONSHIP ID = $relationshipId',
    );

    return _reactions
        .where(
          'relationshipId',
          isEqualTo: relationshipId,
        )
        .snapshots()
        .map(
          (snapshot) {
            debugPrint(
              'REACTIONS RECEIVED = '
              '${snapshot.docs.length}',
            );

            return snapshot.docs
                .map(
                  CloudPartnerReaction.fromFirestore,
                )
                .toList();
          },
        );
  }

  // ==========================================================
  // REACTION BY CORRELATION ID
  // ==========================================================

  static Stream<CloudPartnerReaction?>
      watchReaction(
    String correlationId,
  ) {
    return Stream.fromFuture(
      RelationshipService.getActiveRelationship(),
    ).asyncExpand(
      (relationship) {
        if (relationship == null) {
          return Stream.value(null);
        }

        return _reactions
            .where(
              'relationshipId',
              isEqualTo: relationship.id,
            )
            .where(
              'correlationId',
              isEqualTo: correlationId,
            )
            .limit(1)
            .snapshots()
            .map(
              (snapshot) {
                if (snapshot.docs.isEmpty) {
                  return null;
                }

                return CloudPartnerReaction.fromFirestore(
                  snapshot.docs.first,
                );
              },
            );
      },
    );
  }
}