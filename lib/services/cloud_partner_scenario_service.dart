import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/cloud_partner_scenario.dart';
import 'relationship_service.dart';

class CloudPartnerScenarioService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _scenarios =>
          _firestore.collection(
            'partner_scenarios',
          );

  // ==========================================================
  // SEND SCENARIO
  // ==========================================================

  static Future<void> sendScenario({
    required String receiverUid,
    required String parentScenarioId,
    required String nazev,
    required String text,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    final relationship =
        await RelationshipService.getActiveRelationship();

    if (relationship == null) {
      throw Exception(
        'No active relationship.',
      );
    }

    debugPrint('========== SEND SCENARIO ==========');
    debugPrint('SENDER UID = ${user.uid}');
    debugPrint('RECEIVER UID = $receiverUid');
    debugPrint('RELATIONSHIP ID = ${relationship.id}');

    // DŮLEŽITÉ:
    // Mapu vytváříme přímo zde, aby bylo ve Firebase
    // opravdu pole "receiverUid" a ne omylem "receiveUid".
    await _scenarios.add({
      'relationshipId': relationship.id,

      'senderUid': user.uid,

      // MUSÍ být přesně receiverUid
      'receiverUid': receiverUid,

      'parentScenarioId': parentScenarioId,

      'nazev': nazev,

      'text': text,

      'status': 'received',

      'createdAt':
          FieldValue.serverTimestamp(),
    });

    debugPrint('🟢 SCENARIO SEND DONE');
  }

  // ==========================================================
  // UPDATE STATUS
  // ==========================================================

  static Future<void> updateScenarioStatus(
    String scenarioId,
    String status,
  ) async {
    debugPrint(
      '========== UPDATE SCENARIO ==========',
    );

    debugPrint(
      'DOC ID = $scenarioId',
    );

    debugPrint(
      'STATUS = $status',
    );

    await _scenarios.doc(
      scenarioId,
    ).update({
      'status': status,
    });

    debugPrint(
      'UPDATE DONE',
    );
  }

  // ==========================================================
  // INCOMING SCENARIOS
  // ==========================================================

  static Stream<List<CloudPartnerScenario>>
      incomingScenarios(
    String relationshipId,
  ) {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    debugPrint(
      '========== INCOMING SCENARIOS ==========',
    );

    debugPrint(
      'MY UID = ${user.uid}',
    );

    debugPrint(
      'RELATIONSHIP ID = $relationshipId',
    );

    return _scenarios
        .where(
          'relationshipId',
          isEqualTo: relationshipId,
        )
        .where(
          'receiverUid',
          isEqualTo: user.uid,
        )
        .snapshots()
        .map(
          (snapshot) {
            debugPrint(
              '🟢 RECEIVED SCENARIOS: '
              '${snapshot.docs.length}',
            );

            return snapshot.docs
                .map(
                  CloudPartnerScenario.fromFirestore,
                )
                .toList();
          },
        );
  }

  // ==========================================================
  // SENT SCENARIOS
  // ==========================================================

  static Stream<List<CloudPartnerScenario>>
      sentScenarios(
    String relationshipId,
  ) {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return _scenarios
        .where(
          'relationshipId',
          isEqualTo: relationshipId,
        )
        .where(
          'senderUid',
          isEqualTo: user.uid,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                CloudPartnerScenario.fromFirestore,
              )
              .toList(),
        );
  }
}