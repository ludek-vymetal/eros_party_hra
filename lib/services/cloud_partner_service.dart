import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudPartnerService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _links =>
          _firestore.collection('partner_links');

  static CollectionReference<Map<String, dynamic>>
      get _users =>
          _firestore.collection('users');

  // ==========================================================
  // DISPLAY NAME
  // ==========================================================

  /// Uloží zobrazované jméno aktuálního uživatele.
  static Future<void> saveDisplayName(
    String displayName,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final cleanName = displayName.trim();

    if (cleanName.isEmpty) {
      return;
    }

    await _users.doc(user.uid).set(
      {
        'displayName': cleanName,
        'email': user.email,
      },
      SetOptions(merge: true),
    );
  }

  /// Vrátí zobrazované jméno aktuálně přihlášeného uživatele.
  static Future<String?> getMyDisplayName() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return getUserDisplayName(user.uid);
  }

  /// Vrátí zobrazované jméno libovolného uživatele podle UID.
  ///
  /// Toto využijeme například pro zobrazení jmen obou partnerů
  /// na obálce Relationship Book.
  static Future<String?> getUserDisplayName(
    String uid,
  ) async {
    final snapshot =
        await _users.doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    final displayName =
        snapshot.data()?['displayName'];

    if (displayName is String &&
        displayName.trim().isNotEmpty) {
      return displayName.trim();
    }

    return null;
  }

  // ==========================================================
  // REGISTRACE / ZÍSKÁNÍ VLASTNÍHO KÓDU
  // ==========================================================

  /// Vrátí trvalý partnerský kód aktuálního uživatele.
  ///
  /// Pokud už uživatel kód má, vždy se vrátí stejný.
  /// Nový kód se vytvoří pouze při prvním použití.
  static Future<String?> getOrCreateMyCode(
    String Function() generateCode,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    // --------------------------------------------------------
    // 1. Zkusíme najít existující kód podle UID
    // --------------------------------------------------------

    final existingQuery = await _links
        .where(
          'uid',
          isEqualTo: user.uid,
        )
        .limit(1)
        .get();

    if (existingQuery.docs.isNotEmpty) {
      final data =
          existingQuery.docs.first.data();

      final existingCode =
          data['code'];

      if (existingCode is String &&
          existingCode.isNotEmpty) {
        await _users.doc(user.uid).set(
          {
            'myCode': existingCode,
            'email': user.email,
          },
          SetOptions(merge: true),
        );

        return existingCode;
      }
    }

    // --------------------------------------------------------
    // 2. Zkusíme users/{uid}.myCode
    // --------------------------------------------------------

    final userSnapshot =
        await _users.doc(user.uid).get();

    final userData =
        userSnapshot.data();

    final storedCode =
        userData?['myCode'];

    if (storedCode is String &&
        storedCode.isNotEmpty) {
      await _links.doc(storedCode).set(
        {
          'uid': user.uid,
          'code': storedCode,
          'email': user.email,
          'createdAt':
              FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      return storedCode;
    }

    // --------------------------------------------------------
    // 3. Není žádný kód → vytvoříme nový
    // --------------------------------------------------------

    String newCode;

    while (true) {
      newCode = generateCode();

      final existing =
          await _links.doc(newCode).get();

      if (!existing.exists) {
        break;
      }
    }

    await _links.doc(newCode).set(
      {
        'uid': user.uid,
        'code': newCode,
        'email': user.email,
        'createdAt':
            FieldValue.serverTimestamp(),
      },
    );

    await _users.doc(user.uid).set(
      {
        'myCode': newCode,
        'email': user.email,
      },
      SetOptions(merge: true),
    );

    return newCode;
  }

  // ==========================================================
  // STARŠÍ API
  // ==========================================================

  /// Registruje existující partnerský kód.
  static Future<void> registerMyCode(
    String code,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _links.doc(code).set(
      {
        'uid': user.uid,
        'code': code,
        'email': user.email,
        'createdAt':
            FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await _users.doc(user.uid).set(
      {
        'myCode': code,
        'email': user.email,
      },
      SetOptions(merge: true),
    );
  }

  // ==========================================================
  // PARTNER
  // ==========================================================

  /// Najde UID partnera podle jeho partnerského kódu.
  static Future<String?> findPartnerUid(
    String code,
  ) async {
    final doc =
        await _links.doc(code).get();

    if (!doc.exists) {
      return null;
    }

    final data =
        doc.data();

    final uid = data?['uid'];

    return uid is String ? uid : null;
  }

  // ==========================================================
  // USER DOCUMENT
  // ==========================================================

  /// Zajistí existenci users/{uid}.
  static Future<void> ensureUserDocument() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final doc =
        _users.doc(user.uid);

    final snapshot =
        await doc.get();

    if (snapshot.exists) {
      return;
    }

    await doc.set(
      {
        'email': user.email,
        'createdAt':
            FieldValue.serverTimestamp(),
      },
    );
  }

  // ==========================================================
  // PARTNER UID
  // ==========================================================

  /// Uloží UID partnera aktuálního uživatele.
  static Future<void> savePartnerUid(
    String partnerUid,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _users.doc(user.uid).set(
      {
        'partnerUid': partnerUid,
      },
      SetOptions(merge: true),
    );
  }

  /// Vrátí UID partnera aktuálního uživatele.
  static Future<String?> getPartnerUid() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final snapshot =
        await _users.doc(user.uid).get();

    final partnerUid =
        snapshot.data()?['partnerUid'];

    return partnerUid is String
        ? partnerUid
        : null;
  }

  // ==========================================================
  // MY CODE
  // ==========================================================

  /// Uloží partnerský kód aktuálního uživatele.
  static Future<void> saveMyCode(
    String code,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _users.doc(user.uid).set(
      {
        'myCode': code,
        'email': user.email,
      },
      SetOptions(merge: true),
    );
  }
}