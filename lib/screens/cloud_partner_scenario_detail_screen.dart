import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/cloud_partner_scenario.dart';
import '../models/reaction.dart';
import '../models/scenar.dart';
import '../models/scenario_record.dart';
import '../services/cloud_partner_reaction_service.dart';
import '../services/cloud_partner_scenario_service.dart';
import '../services/partner_link_service.dart';
import '../services/scenario_record_storage.dart';
import '../relationship_book/models/relationship_event.dart';

import '../relationship_book/engine/chapter_engine.dart';
import '../relationship_book/repositories/firestore_relationship_book_repository.dart';
import '../relationship_book/models/relationship_scenario.dart';
import 'package:uuid/uuid.dart';
import '../relationship_book/models/relationship_reflection.dart';
import '../relationship_book/services/relationship_reflection_service.dart';
import '../relationship_book/repositories/cloud/cloud_relationship_reflection_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudPartnerScenarioDetailScreen extends StatelessWidget {
  final CloudPartnerScenario scenario;

  CloudPartnerScenarioDetailScreen({
    super.key,
    required this.scenario,
  });
  final ChapterEngine _chapterEngine =
      ChapterEngine(
        repository: FirestoreRelationshipBookRepository(),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scenarioDetail),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scenario.nazev,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(_getStatusLabel(scenario.status, l10n)),
            const SizedBox(height: 16),
            Text(
              '${l10n.sentAt}: ${scenario.createdAt.day}.${scenario.createdAt.month}.${scenario.createdAt.year}',
            ),
            const SizedBox(height: 24),
            Text(scenario.text),
            const SizedBox(height: 32),
            if (scenario.status == 'rejected') _buildReconsiderButton(context, l10n),
            if (scenario.status == 'received' || scenario.status == 'postponed')
              _buildReactButton(context, l10n),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(String status, AppLocalizations l10n) {
    return switch (status) {
      'completed' => l10n.completed,
      'postponed' => l10n.postponedStatus,
      'rejected' => l10n.rejectedStatus,
      _ => l10n.receivedStatus,
    };
  }

  Widget _buildReconsiderButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.rejectedScenarioInfo,
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              try {
                await CloudPartnerScenarioService
                    .updateScenarioStatus(
                  scenario.id,
                  'postponed',
                );
              } catch (e) {
                developer.log(
                  'Update failed',
                  error: e,
                  name: 'CloudPartnerScenario',
                );
              }

              if (!context.mounted) {
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.reactionSent,
                  ),
                ),
              );

              Navigator.pop(context);
            },
            child: Text(
              l10n.reconsiderScenario,
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Widget _buildReactButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleReaction(context, l10n),
        child: Text(l10n.reactToScenario),
      ),
    );
  }

  Future<void> _handleReaction(BuildContext context, AppLocalizations l10n) async {
    final controller = TextEditingController();
    String selectedStatus = 'completed';

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.sendReactionTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedStatus,
                decoration: InputDecoration(
                  labelText: l10n.reactionDecision,
                ),
                items: [
                  DropdownMenuItem(value: 'completed', child: Text(l10n.reactionComplete)),
                  DropdownMenuItem(value: 'postponed', child: Text(l10n.reactionPostpone)),
                  DropdownMenuItem(value: 'rejected', child: Text(l10n.reactionReject)),
                ],
                onChanged: (value) => setState(() => selectedStatus = value ?? 'completed'),
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(hintText: l10n.reactionMessage),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {'message': controller.text, 'status': selectedStatus}),
              child: Text(l10n.send),
            ),
          ],
        ),
      ),
    );

    if (result == null || !context.mounted) return;

    final message = result['message'] as String;
    final status = result['status'] as String;

    if (message.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.reactionMessageRequired)));
      return;
    }

    try {
      debugPrint("DEBUG: Starting reaction flow for scenario: ${scenario.id}");

      final partnerUid = await PartnerLinkService.getPartnerUid();
      if (partnerUid == null) {
        debugPrint("DEBUG: Partner UID is NULL");
        return;
      }

      await CloudPartnerReactionService.sendReaction(
        receiverUid: partnerUid,
        scenarioName: scenario.nazev,
        scenarioId: scenario.id,
        message: message.trim(),
        completed: status == 'completed',
      );

      await CloudPartnerScenarioService.updateScenarioStatus(scenario.id, status);
      debugPrint("DEBUG: Scenario status updated to $status");

      final localScenar = Scenar(
        id: scenario.id,
        autor: '',
        pro: '',
        nazev: scenario.nazev,
        cil: '',
        text: scenario.text,
        hranice: '',
        emoce: const [],
      );

      final record = ScenarioRecord(
        id: scenario.id,
        parentScenarioId: scenario.parentScenarioId,
        scenar: localScenar,
        reactions: [
          Reaction(
            scenarioId: scenario.parentScenarioId,
            nazev: scenario.nazev,
            stav: status,
            vzkaz: message.trim(),
            datum: DateTime.now(),
          ),
        ],
      );

      await ScenarioRecordStorage.add(record);
      debugPrint("DEBUG: Local storage updated");
      debugPrint("1 CREATE CHAPTER");

      await _chapterEngine.createChapterFromScenario(
        scenario: RelationshipScenario(
          scenarioId: scenario.id,
          parentScenarioId: scenario.parentScenarioId,
          title: scenario.nazev,
          description: scenario.text,
          status: status,
          createdAt: DateTime.now(),
        ),
      );
      final chapter = await _chapterEngine.findChapterByScenario(
        scenario.id,
      );

      if (chapter != null) {
        final now = DateTime.now();

        final reflection = RelationshipReflection(
          id: const Uuid().v4(),
          chapterId: chapter.id,
          authorId: FirebaseAuth.instance.currentUser!.uid,
          text: message.trim(),
          createdAt: now,
          updatedAt: now,
        );

        await RelationshipReflectionService(
          repository: CloudRelationshipReflectionRepository(),
        ).saveReflection(reflection);
      }
      debugPrint("2 CREATE CHAPTER OK");
      if (!context.mounted) return;
      debugPrint("3 SHOW DIALOG");
      final saveToJournal = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.saveToRelationshipJournal),
          content: Text(l10n.saveToRelationshipJournalQuestion),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        ),
      ) ?? false;

      if (!context.mounted) return;

      if (saveToJournal) {
        final chapterController = TextEditingController();
        final chapterTitle = await showDialog<String>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(l10n.chapterTitle),
            content: TextField(
              controller: chapterController,
              decoration: InputDecoration(hintText: l10n.chapterTitle),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, chapterController.text.trim()),
                child: Text(MaterialLocalizations.of(context).okButtonLabel),
              ),
            ],
          ),
        );

        if (!context.mounted) return;

        if (chapterTitle != null && chapterTitle.isNotEmpty) {
          String introduction = '';
          final writeIntroduction = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(l10n.sharedMemory),
              content: Text(l10n.saveToRelationshipJournalQuestion),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.skip),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.write),
                ),
              ],
            ),
          ) ?? false;

          if (!context.mounted) return;

          if (writeIntroduction) {
            final introController = TextEditingController();
            final intro = await showDialog<String>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(l10n.ourThoughts),
                content: SizedBox(
                  width: 400,
                  child: TextField(
                    controller: introController,
                    maxLines: 8,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.relationshipStory,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, introController.text.trim()),
                    child: Text(MaterialLocalizations.of(context).okButtonLabel),
                  ),
                ],
              ),
            );

            if (!context.mounted) return;

            introduction = intro ?? '';
          }

          await _chapterEngine.updateIntroduction(
            scenarioId: scenario.id,
            chapterTitle: chapterTitle,
            introduction: introduction,
          );
        }
          await _chapterEngine.addEvent(
            scenarioId: scenario.id,
            event: RelationshipEvent(
              id: const Uuid().v4(),
              type: RelationshipEventType.noteAdded,
              createdAt: DateTime.now(),
              authorUid: '',
              description: 'Autor přidal úvod kapitoly.',
            ),
          );

          if (!context.mounted) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.reactionSent),
            ),
          );

          Navigator.pop(context);
          }
    } catch (e) {
      developer.log("ERROR: Handle reaction failed", error: e, name: 'CloudPartnerScenario');

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chyba: $e")),
      );
    }
  }
}