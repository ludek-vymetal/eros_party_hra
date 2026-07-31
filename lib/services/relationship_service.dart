import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/relationship.dart';

class RelationshipService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static const _activeRelationshipKey = 'active_relationship_id';

  static CollectionReference<Map<String, dynamic>> get _relationships =>
      _firestore.collection('relationships');

  // ==========================================================
  // RELATIONSHIP
  // ==========================================================

  static Future<Relationship> getOrCreateRelationship({
    required String partnerUid,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    final snapshot = await _relationships.get();

    for (final doc in snapshot.docs) {
      final relationship = Relationship.fromFirestore(
        doc.id,
        doc.data(),
      );

      final match =
          (relationship.user1Uid == user.uid &&
                  relationship.user2Uid == partnerUid) ||
              (relationship.user1Uid == partnerUid &&
                  relationship.user2Uid == user.uid);

      if (match) {
        return relationship;
      }
    }

    final doc = _relationships.doc();

    final relationship = Relationship(
      id: doc.id,
      user1Uid: user.uid,
      user2Uid: partnerUid,
      createdAt: DateTime.now(),
    );

    await doc.set(
      relationship.toMap(),
    );

    return relationship;
  }

  static Future<void> setActiveRelationship(
    String relationshipId,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _activeRelationshipKey,
      relationshipId,
    );
  }

  static Future<String?> getActiveRelationshipId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      _activeRelationshipKey,
    );
  }

  static Future<void> clearActiveRelationship() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      _activeRelationshipKey,
    );
  }

  static Future<Relationship?> getActiveRelationship() async {
    final relationshipId = await getActiveRelationshipId();

    if (relationshipId == null) {
      return null;
    }

    final doc = await _relationships.doc(
      relationshipId,
    ).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return Relationship.fromFirestore(
      doc.id,
      doc.data()!,
    );
  }

  static Future<DocumentReference<Map<String, dynamic>>>
      relationshipDocument() async {
    final relationshipId = await getActiveRelationshipId();

    if (relationshipId == null) {
      throw Exception(
        'No active relationship.',
      );
    }

    return _relationships.doc(
      relationshipId,
    );
  }

  // ==========================================================
  // SUBCOLLECTIONS
  // ==========================================================

  static Future<CollectionReference<Map<String, dynamic>>>
      scenarios() async {
    final doc = await relationshipDocument();

    return doc.collection(
      'scenarios',
    );
  }

  static Future<CollectionReference<Map<String, dynamic>>>
      reactions() async {
    final doc = await relationshipDocument();

    return doc.collection(
      'reactions',
    );
  }

  static Future<CollectionReference<Map<String, dynamic>>>
      relationshipBook() async {
    final doc = await relationshipDocument();

    return doc.collection(
      'relationship_book',
    );
  }

  static Future<CollectionReference<Map<String, dynamic>>>
      photos() async {
    final doc = await relationshipDocument();

    return doc.collection(
      'photos',
    );
  }

  static Future<CollectionReference<Map<String, dynamic>>>
      reflections() async {
    final doc = await relationshipDocument();

    return doc.collection(
      'reflections',
    );
  }

  static Future<CollectionReference<Map<String, dynamic>>>
      settings() async {
    final doc = await relationshipDocument();

    return doc.collection(
      'settings',
    );
  }

  // ==========================================================
  // HELPERS
  // ==========================================================

  static Future<String?> getPartnerUid() async {
    final relationship = await getActiveRelationship();

    if (relationship == null) {
      return null;
    }

    final myUid = _auth.currentUser?.uid;

    if (myUid == null) {
      return null;
    }

    if (relationship.user1Uid == myUid) {
      return relationship.user2Uid;
    }

    if (relationship.user2Uid == myUid) {
      return relationship.user1Uid;
    }

    return null;
  }
}