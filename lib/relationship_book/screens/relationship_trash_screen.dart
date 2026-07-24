import 'package:flutter/material.dart';

import '../models/relationship_chapter.dart';
import '../services/relationship_trash_service.dart';

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

  Future<void> _restoreChapter(RelationshipChapter chapter) async {
    await _trashService.restoreChapter(chapter.id);

    if (!mounted) {
      return;
    }

    await _loadTrash();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kapitola "${chapter.chapterTitle}"Vzpomínka byla vrácena zpět do vaší knihy.',),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koš'),
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
                      child: ListTile(
                        leading: const Icon(
                          Icons.delete_outline,
                        ),
                        title: Text(
                          chapter.chapterTitle,
                        ),
                        subtitle: Text(
                          chapter.scenario.title,
                        ),
                        trailing: IconButton(
                          tooltip: 'Obnovit',
                          icon: const Icon(
                            Icons.restore,
                            color: Colors.green,
                          ),
                          onPressed: () => _restoreChapter(chapter),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}