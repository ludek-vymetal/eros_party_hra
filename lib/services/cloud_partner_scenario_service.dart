import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cloud_partner_scenario.dart';

class CloudPartnerScenarioService {
  static final _firestore =
      FirebaseFirestore.instance;

  static final _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _scenarios =>
          _firestore.collection(
            'partner_scenarios',
          );

  static Future<void> sendScenario({
    required String receiverUid,
    required String nazev,
    required String text,
  }) async {
    final user =
        _auth.currentUser;

    if (user == null) {
      return;
    }

    final scenario =
        CloudPartnerScenario(
      id: '',
      senderUid: user.uid,
      receiverUid: receiverUid,
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
    await _scenarios
        .doc(scenarioId)
        .update({
      'status': status,
    });
  }

  static Stream<List<CloudPartnerScenario>>
      incomingScenarios(
    String myUid,
  ) {
    return _scenarios
        .where(
          'receiverUid',
          isEqualTo: myUid,
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