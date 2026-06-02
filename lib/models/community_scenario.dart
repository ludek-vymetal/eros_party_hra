import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityScenario {
  final String id;
  final String nazev;
  final String autor;
  final String pro;
  final String cil;
  final String text;
  final String hranice;
  final List<String> emoce;
  final String authorUid;
  final bool anonymous;
  final int likes;
  final DateTime createdAt;

  const CommunityScenario({
    required this.id,
    required this.nazev,
    required this.autor,
    required this.pro,
    required this.cil,
    required this.text,
    required this.hranice,
    required this.emoce,
    required this.authorUid,
    required this.anonymous,
    required this.likes,
    required this.createdAt,
  });

  factory CommunityScenario.fromFirestore(
    DocumentSnapshot doc,
  ) {
    final data =
        doc.data() as Map<String, dynamic>;

    return CommunityScenario(
      id: doc.id,
      nazev: data['nazev'] ?? '',
      autor: data['autor'] ?? '',
      pro: data['pro'] ?? '',
      cil: data['cil'] ?? '',
      text: data['text'] ?? '',
      hranice: data['hranice'] ?? '',
      emoce: List<String>.from(
        data['emoce'] ?? [],
      ),
      authorUid:
          data['authorUid'] ?? '',
      anonymous:
          data['anonymous'] ?? false,
      likes: data['likes'] ?? 0,
      createdAt:
          (data['createdAt']
                  as Timestamp?)
              ?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nazev': nazev,
      'autor': autor,
      'pro': pro,
      'cil': cil,
      'text': text,
      'hranice': hranice,
      'emoce': emoce,
      'authorUid': authorUid,
      'anonymous': anonymous,
      'likes': likes,
      'createdAt':
          FieldValue.serverTimestamp(),
    };
  }
}