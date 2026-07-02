import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/relationship_chapter.dart';
import '../models/scenario_record.dart';
class RelationshipJournalStorage {
  static const _key = 'relationship_journal';

  static Future<List<RelationshipChapter>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List;

    return decoded
        .map(
          (e) => RelationshipChapter.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }

  static Future<void> saveAll(
    List<RelationshipChapter> chapters,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      jsonEncode(
        chapters.map((e) => e.toJson()).toList(),
      ),
    );
  }

  static Future<void> add(
    RelationshipChapter chapter,
  ) async {
    final chapters = await getAll();

    chapters.add(chapter);

    await saveAll(chapters);
  }

  static Future<void> delete(
    String id,
  ) async {
    final chapters = await getAll();

    chapters.removeWhere(
      (c) => c.id == id,
    );

    await saveAll(chapters);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
  static Future<void> addChapter(
    RelationshipChapter chapter,
  ) async {
    final chapters = await getAll();

    chapters.add(chapter);

    await saveAll(chapters);
  }
  static Future<void> createChapter({
    required ScenarioRecord record,
    required String chapterTitle,
    required String introduction,
    String? imagePath,
  }) async {
    final chapter = RelationshipChapter(
      id: '${DateTime.now().microsecondsSinceEpoch}_${record.id}',
      createdAt: DateTime.now(),
      record: record,
      chapterTitle: chapterTitle,
      introduction: introduction,
      imagePath: imagePath,
    );

    await addChapter(chapter);

  }
  static Future<void> updateChapter(
    RelationshipChapter chapter,
  ) async {
    final chapters = await getAll();

    final index = chapters.indexWhere(
      (c) => c.id == chapter.id,
    );

    if (index == -1) {
      return;
    }

    chapters[index] = chapter;

    await saveAll(chapters);
  }  
}