import 'package:flutter/material.dart';

import '../models/relationship_chapter.dart';
import '../services/relationship_journal_storage.dart';

class EditRelationshipChapterScreen extends StatefulWidget {
  final RelationshipChapter chapter;

  const EditRelationshipChapterScreen({
    super.key,
    required this.chapter,
  });

  @override
  State<EditRelationshipChapterScreen> createState() =>
      _EditRelationshipChapterScreenState();
}

class _EditRelationshipChapterScreenState
    extends State<EditRelationshipChapterScreen> {
  late final TextEditingController chapterController;
  late final TextEditingController introductionController;
  late final TextEditingController authorController;
  late final TextEditingController partnerController;

  @override
  void initState() {
    super.initState();

    chapterController = TextEditingController(
      text: widget.chapter.chapterTitle,
    );

    introductionController = TextEditingController(
      text: widget.chapter.introduction,
    );

    authorController = TextEditingController(
      text: widget.chapter.authorReflection,
    );

    partnerController = TextEditingController(
      text: widget.chapter.partnerReflection,
    );
  }

  @override
  void dispose() {
    chapterController.dispose();
    introductionController.dispose();
    authorController.dispose();
    partnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upravit kapitolu",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: chapterController,
              decoration: const InputDecoration(
                labelText: "Název kapitoly",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: introductionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Úvod",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: authorController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Moje myšlenky",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: partnerController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Partnerovy myšlenky",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            FilledButton(
              onPressed: () async {
                final updated = widget.chapter.copyWith(
                  chapterTitle: chapterController.text.trim(),
                  introduction: introductionController.text.trim(),
                  authorReflection: authorController.text.trim(),
                  partnerReflection: partnerController.text.trim(),
                );

                await RelationshipJournalStorage.updateChapter(
                  updated,
                );

                if (!context.mounted) {
                  return;
                }

                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                "💾 Uložit",
              ),
            ),
          ],
        ),
      ),
    );
  }
}