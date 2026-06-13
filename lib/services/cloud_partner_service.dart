import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudPartnerService {
  static final _firestore =
      FirebaseFirestore.instance;

  static final _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _links =>
          _firestore.collection(
            'partner_links',
          );

  /// Registrace vlastního kódu do Firebase
  static Future<void> registerMyCode(
    String code,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _links.doc(code).set({
      'uid': user.uid,
      'code': code,
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }

  /// Najde UID partnera podle kódu
  static Future<String?> findPartnerUid(
    String code,
  ) async {
    final doc =
        await _links.doc(code).get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data();

    return data?['uid'];
  }

  /// vytvoří dokument uživatele v kolekci users
  static Future<void> ensureUserDocument() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final doc = _firestore
        .collection('users')
        .doc(user.uid);

    final snapshot = await doc.get();

    if (snapshot.exists) {
      return;
    }

    await doc.set({
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }
  /// uloží partnerovo UID do users/UID
static Future<void> savePartnerUid(
  String partnerUid,
) async {
  final user = _auth.currentUser;

  if (user == null) {
    return;
  }

  await _firestore
      .collection('users')
      .doc(user.uid)
      .set(
    {
      'partnerUid': partnerUid,
    },
    SetOptions(
      merge: true,
    ),
  );
}

/// načte partnerovo UID z users/UID
static Future<String?> getPartnerUid() async {
  final user = _auth.currentUser;

  if (user == null) {
    return null;
  }

  final snapshot =
      await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

  return snapshot.data()?['partnerUid'];
}

  /// uloží vlastní partnerský kód do users/UID
  static Future<void> saveMyCode(
    String code,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(
      {
        'myCode': code,
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}