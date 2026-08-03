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

  static Future<void> sendScenario({
    required String receiverUid,
    required String parentScenarioId,
    required String nazev,
    required String text,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final relationship =
        await RelationshipService.getActiveRelationship();

    if (relationship == null) {
      throw Exception(
        'No active relationship.',
      );
    }

    final scenario = CloudPartnerScenario(
      id: '',
      relationshipId: relationship.id,
      senderUid: user.uid,
      receiverUid: receiverUid,
      parentScenarioId: parentScenarioId,
      nazev: nazev,
      text: text,
      status: 'received',
      createdAt: DateTime.now(),
    );

    await _scenarios.add(
      scenario.toMap(),
    );
  }

  static Future<void> updateScenarioStatus(
    String scenarioId,
    String status,
  ) async {
    debugPrint(
      '========== UPDATE SCENARIO =========='
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

  static Stream<List<CloudPartnerScenario>>
      incomingScenarios(
    String relationshipId,
  ) {
    return _scenarios
        .where(
          'relationshipId',
          isEqualTo: relationshipId,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                CloudPartnerScenario
                    .fromFirestore,
              )
              .toList(),
        );
  }
}