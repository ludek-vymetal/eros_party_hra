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
}