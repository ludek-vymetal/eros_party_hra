import 'package:flutter/material.dart';

import '../models/relationship_chapter.dart';
import '../services/relationship_trash_service.dart';
import '../services/relationship_chapter_service.dart';

class RelationshipTrashScreen extends StatefulWidget {
  const RelationshipTrashScreen({
    super.key,
  });

  @override
  State<RelationshipTrashScreen> createState() =>
      _RelationshipTrashScreenState();
}

class _RelationshipTrashScreenState
    extends State<RelationshipTrashScreen> {
  final RelationshipTrashService _trashService =
      RelationshipTrashService();

  final RelationshipChapterService _chapterService =
    RelationshipChapterService();    

  List<RelationshipChapter> _chapters = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTrash();
  }

  Future<void> _loadTrash() async {
    final chapters = await _trashService.getTrash();

    if (!mounted) {
      return;
    }

    setState(() {
      _chapters = chapters;
      _loading = false;
    });
  }

  Future<void> _restoreChapter(
    RelationshipChapter chapter,
  ) async {
    await _trashService.restoreChapter(
      chapter.id,
    );

    if (!mounted) {
      return;
    }

    await _loadTrash();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vzpomínka "${chapter.chapterTitle}" byla úspěšně obnovena.',
        ),
        duration: const Duration(
          seconds: 3,
        ),
      ),
    );
  }
  Future<void> _deleteForever(
    RelationshipChapter chapter,
  ) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Smazat navždy?',
        ),
        content: const Text(
          'Tato vzpomínka bude nenávratně odstraněna.\n\n'
          'Budou odstraněny také všechny fotografie a další navázaná data.\n\n'
          'Tuto akci již nelze vrátit zpět.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },
            child: const Text(
              'Zrušit',
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },
            child: const Text(
              'Smazat navždy',
            ),
          ),
        ],
      ),
    );

    if (delete != true) {
      return;
    }

    await _chapterService.deleteChapterForever(
      chapter.id,
    );

    if (!mounted) {
      return;
    }

    await _loadTrash();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vzpomínka "${chapter.chapterTitle}" byla trvale odstraněna.',
        ),
      ),
    );
  }
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Koš',
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _chapters.isEmpty
              ? const Center(
                  child: Text(
                    'Koš je prázdný',
                  ),
                )
              : ListView.builder(
                  itemCount: _chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = _chapters[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    chapter.chapterTitle,
                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              chapter.scenario.title,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            Row(
                              children: [
                                FilledButton.icon(
                                  onPressed: () =>
                                      _restoreChapter(
                                    chapter,
                                  ),
                                  icon: const Icon(
                                    Icons.restore,
                                  ),
                                  label: const Text(
                                    'Obnovit',
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                OutlinedButton.icon(
                                  onPressed: () => _deleteForever(
                                    chapter,
                                  ),
                                  icon: const Icon(
                                    Icons.delete_forever,
                                  ),
                                  label: const Text(
                                    'Smazat navždy',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}