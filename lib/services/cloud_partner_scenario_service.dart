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
    required String parentScenarioId,
    required String nazev,
    required String text,
    required String cil,
    required String hranice,
    required List<String> emoce,
    required String autor,
    required String pro,
  }) async {
  final user = _auth.currentUser;
  if (user == null) return;

  // Vytvoříme mapu přímo, abychom měli kontrolu nad tím, 
  // co přesně do Firebase posíláme.
  final Map<String, dynamic> scenarioData = {
    'senderUid': user.uid,
    'receiverUid': receiverUid,
    'parentScenarioId': parentScenarioId,

    'nazev': nazev,
    'text': text,
    'cil': cil,
    'hranice': hranice,
    'emoce': emoce,
    'autor': autor,
    'pro': pro,

    'status': 'received',
    'createdAt': FieldValue.serverTimestamp(),
  };

  try {
    await _scenarios.add(scenarioData);
    print("DEBUG: Scénář úspěšně odeslán do Firebase.");
  } catch (e) {
    print("DEBUG: CHYBA PŘI ODESÍLÁNÍ: $e");
  }
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