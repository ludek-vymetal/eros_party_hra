import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
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

class CloudPartnerScenarioDetailScreen extends StatelessWidget {
  final CloudPartnerScenario scenario;

  const CloudPartnerScenarioDetailScreen({
    super.key,
    required this.scenario,
  });

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

  Widget _buildReconsiderButton(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.rejectedScenarioInfo),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              debugPrint("DEBUG: Reconsidering scenario ID: ${scenario.id}");
              try {
                await CloudPartnerScenarioService.updateScenarioStatus(scenario.id, 'postponed');
                debugPrint("DEBUG: Update POSTPONED OK");
              } catch (e) {
                developer.log("ERROR: Update failed", error: e, name: 'CloudPartnerScenario');
              }

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.reactionSent)));
              Navigator.pop(context);
            },
            child: Text(l10n.reconsiderScenario),
          ),
        ),
        const SizedBox(height: 24),
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
                value: selectedStatus,
                decoration: InputDecoration(labelText: l10n.reactionDecision),
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

      debugPrint("SCENARIO.ID = ${scenario.id}");
      debugPrint("PARENT.ID = ${scenario.parentScenarioId}");

      await CloudPartnerScenarioService.updateScenarioStatus(
        scenario.id,
        status,
      );

      debugPrint("STATUS UPDATED");

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
        emoce: [],
      );

      await ScenarioRecordStorage.add(
        ScenarioRecord(
          id: scenario.id,
          parentScenarioId: scenario.parentScenarioId,
          scenar: localScenar,
        ),
      );

      await ScenarioRecordStorage.addReaction(
        scenario.parentScenarioId,
        Reaction(
          scenarioId: scenario.parentScenarioId,
          nazev: scenario.nazev,
          stav: status,
          vzkaz: message.trim(),
          datum: DateTime.now(),
        ),
      );
      debugPrint("DEBUG: Local storage updated");

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.reactionSent)));
      Navigator.pop(context);
      
    } catch (e) {
      developer.log("ERROR: Handle reaction failed", error: e, name: 'CloudPartnerScenario');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Chyba: $e")));
    }
  }
}