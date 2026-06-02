import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/community_scenario.dart';
import '../models/scenar.dart';

class CommunityScenarioService {
  static final _firestore =
      FirebaseFirestore.instance;

  static final _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _scenarios =>
          _firestore.collection(
            'community_scenarios',
          );

  static Future<void> uploadScenario({
    required Scenar scenar,
    required bool anonymous,
  }) async {
    

    final user = _auth.currentUser;

    
    
    if (user == null) {
      
      return;
    }

    final scenario = CommunityScenario(
      id: '',
      nazev: scenar.nazev,
      autor: scenar.autor,
      pro: scenar.pro,
      cil: scenar.cil,
      text: scenar.text,
      hranice: scenar.hranice,
      emoce: scenar.emoce,
      authorUid: user.uid,
      anonymous: anonymous,
      likes: 0,
      createdAt: DateTime.now(),
    );

    await _scenarios.add(
      scenario.toMap(),
    );
    }

  static Stream<List<CommunityScenario>>
      latestScenarios() {
    return _scenarios
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                CommunityScenario
                    .fromFirestore,
              )
              .toList(),
        );
  }

  static Stream<List<CommunityScenario>>
      topScenarios() {
    return _scenarios
        .orderBy(
          'likes',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                CommunityScenario
                    .fromFirestore,
              )
              .toList(),
        );
  }

  static Future<void> likeScenario(
    String scenarioId,
  ) async {
    await _scenarios
        .doc(scenarioId)
        .update({
      'likes':
          FieldValue.increment(1),
    });
  }

  static Future<void> reportScenario(
    String scenarioId,
  ) async {
    final user =
        _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection(
          'reported_scenarios',
        )
        .add({
      'scenarioId': scenarioId,
      'reporterUid': user.uid,
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }
}