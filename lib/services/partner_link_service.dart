import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartnerLinkService {
  PartnerLinkService._();

  static const _keyMyCode = 'my_partner_code';
  static const _keyMyCodeUid = 'my_partner_code_uid';

  static const _keyPartnerCode = 'partner_code';
  static const _keyPartnerUid = 'partner_uid';

  // TODO(MIGRATION):
  // Po dokončení migrace na RelationshipService odstranit.
  static const _keyRelationshipId = 'relationship_id';

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  // ==========================================================
  // MY PARTNER CODE
  // ==========================================================

  /// Vrátí trvalý párovací kód aktuálně přihlášeného uživatele.
  ///
  /// Kód je uložený ve Firestore u konkrétního UID.
  ///
  /// Při první migraci se případně použije starý lokální kód
  /// ze SharedPreferences, aby uživatel nepřišel o svůj původní kód.
  static Future<String> getOrCreateMyCode() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    final uid = user.uid;
    final prefs = await SharedPreferences.getInstance();

    final userDoc = await _users.doc(uid).get();
    final data = userDoc.data();

    // ----------------------------------------------------------
    // 1. Kód už existuje ve Firestore
    // ----------------------------------------------------------

    final firestoreCode = data?['partnerCode'];

    if (firestoreCode is String &&
        firestoreCode.isNotEmpty) {
      await prefs.setString(
        _keyMyCode,
        firestoreCode,
      );

      await prefs.setString(
        _keyMyCodeUid,
        uid,
      );

      return firestoreCode;
    }

    // ----------------------------------------------------------
    // 2. MIGRACE STARÉHO LOKÁLNÍHO KÓDU
    // ----------------------------------------------------------
    //
    // Pokud máme starý kód, například HSSG8K,
    // zachováme ho a uložíme ho k aktuálnímu UID.
    //

    final localCode = prefs.getString(_keyMyCode);
    final localCodeUid = prefs.getString(_keyMyCodeUid);

    if (localCode != null &&
        localCode.isNotEmpty &&
        (localCodeUid == null || localCodeUid == uid)) {
      await _users.doc(uid).set(
        {
          'partnerCode': localCode,
          'email': user.email,
        },
        SetOptions(merge: true),
      );

      await prefs.setString(
        _keyMyCodeUid,
        uid,
      );

      return localCode;
    }

    // ----------------------------------------------------------
    // 3. Vygenerujeme úplně nový kód
    // ----------------------------------------------------------

    final newCode = _generateCode();

    await _users.doc(uid).set(
      {
        'partnerCode': newCode,
        'email': user.email,
      },
      SetOptions(merge: true),
    );

    await prefs.setString(
      _keyMyCode,
      newCode,
    );

    await prefs.setString(
      _keyMyCodeUid,
      uid,
    );

    return newCode;
  }

  // ==========================================================
  // PARTNER CODE
  // ==========================================================

  /// Uloží partnerský kód.
  static Future<void> savePartnerCode(
    String code,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _keyPartnerCode,
      code,
    );
  }

  // ==========================================================
  // PARTNER UID
  // ==========================================================

  /// Uloží UID partnera.
  static Future<void> savePartnerUid(
    String uid,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _keyPartnerUid,
      uid,
    );
  }

  /// Vrátí UID partnera.
  static Future<String?> getPartnerUid() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      _keyPartnerUid,
    );
  }

  // ==========================================================
  // LINK STATUS
  // ==========================================================

  /// Vrátí true, pokud je partner propojen.
  static Future<bool> isLinked() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(
      _keyPartnerCode,
    );
  }

  // ==========================================================
  // UNLINK
  // ==========================================================

  /// Odpojí partnera.
  ///
  /// Vlastní párovací kód se NEMAŽE.
  /// Ten patří uživatelskému účtu a musí zůstat trvalý.
  static Future<void> unlink() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      _keyPartnerCode,
    );

    await prefs.remove(
      _keyPartnerUid,
    );

    // Přechodně kvůli kompatibilitě.
    await prefs.remove(
      _keyRelationshipId,
    );
  }

  // ==========================================================
  // RESET MY CODE
  // ==========================================================

  /// Úplně smaže vlastní párovací kód.
  ///
  /// Toto je skutečný RESET kódu.
  /// Při dalším volání getOrCreateMyCode()
  /// vznikne nový kód.
  static Future<void> resetMyCode() async {
    final user = _auth.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      await _users.doc(user.uid).set(
        {
          'partnerCode': FieldValue.delete(),
        },
        SetOptions(merge: true),
      );
    }

    await prefs.remove(
      _keyMyCode,
    );

    await prefs.remove(
      _keyMyCodeUid,
    );
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

  /// Vyčistí lokální údaje při odhlášení účtu.
  ///
  /// POZOR:
  /// Vlastní partnerCode se NEMAŽE.
  /// Je uložený ve Firestore u UID uživatele.
  static Future<void> clearForLogout() async {
    final prefs = await SharedPreferences.getInstance();

    // Vlastní kód NESMAZAT.
    //
    // _keyMyCode
    // _keyMyCodeUid
    //
    // zůstávají kvůli lokální cache a migraci.

    await prefs.remove(
      _keyPartnerCode,
    );

    await prefs.remove(
      _keyPartnerUid,
    );

    await prefs.remove(
      _keyRelationshipId,
    );
  }

  // ==========================================================
  // RELATIONSHIP MIGRATION
  // ==========================================================

  static Future<void> saveRelationshipId(
    String relationshipId,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _keyRelationshipId,
      relationshipId,
    );
  }

  static Future<String?> getRelationshipId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      _keyRelationshipId,
    );
  }

  // ==========================================================
  // CODE GENERATOR
  // ==========================================================

  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    final rand = Random.secure();

    return List.generate(
      6,
      (index) {
        return chars[rand.nextInt(chars.length)];
      },
    ).join();
  }
}