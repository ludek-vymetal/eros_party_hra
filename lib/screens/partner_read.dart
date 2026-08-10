import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/app_localizations.dart';

import '../models/scenar.dart';
import '../models/reaction.dart';
import '../models/scenario_record.dart';

import '../services/crypto_service.dart';
import '../services/scenario_record_storage.dart';

import 'partner_reaction_detail.dart';
import '../relationship_book/engine/chapter_engine.dart';
import '../relationship_book/repositories/firestore_relationship_book_repository.dart';
import '../relationship_book/mappers/relationship_scenario_mapper.dart';

class PartnerReadScreen
    extends StatefulWidget {
  const PartnerReadScreen({
    super.key,
  });

  @override
  State<PartnerReadScreen>
      createState() =>
          _PartnerReadScreenState();
}

class _PartnerReadScreenState
    extends State<
        PartnerReadScreen> {
  final TextEditingController
      _codeCtrl =
      TextEditingController();

  final TextEditingController
      _vzkazCtrl =
      TextEditingController();



  final ImagePicker _picker =
      ImagePicker();

  final ChapterEngine _chapterEngine =
      ChapterEngine(
        repository:
            FirestoreRelationshipBookRepository(),
      );    

  File? _photo;

  Scenar? scenar;

  ScenarioRecord? record;

  String? error;

  // =========================
  // 🧠 EMOTIONS
  // =========================

  late List<String> _emoce;

  String _vybranaEmoce = '';

  // =========================
  // ✅ DECISION
  // =========================

  late List<String> _stavy;

  String _stav = '';

  @override
  void dispose() {
    _codeCtrl.dispose();
    _vzkazCtrl.dispose();

    super.dispose();
  }

  // ================= DECODE =================

  Future<void> _decode() async {
    final l10n =
        AppLocalizations.of(context);

    setState(() {
      error = null;
      scenar = null;
      record = null;
    });

    try {
      final decoded =
          CryptoService
              .decodeScenar(
        _codeCtrl.text.trim(),
      );

      final existing =
          await ScenarioRecordStorage
              .getById(
        decoded.id,
      );
      final chapter = await _chapterEngine.findChapterByScenario(
        record!.id,
      );

      debugPrint(
        'Relationship Chapter: ${chapter?.chapterTitle}',
      );
      // TODO(RB-017):
      // Pokud partner scénář přijme,
      // automaticky vytvořit RelationshipChapter.
      setState(() {
        scenar = decoded;

        record =
            existing ??
                ScenarioRecord(
                  id: decoded.id,
                  scenar: decoded,
                );
      });

      if (existing == null) {
        await ScenarioRecordStorage
            .add(record!);
      }
    } catch (_) {
      setState(() {
        error =
            l10n.invalidCode;
      });
    }
  }

  // ================= PHOTO =================

  Future<void> _pickPhoto() async {
    final picked =
        await _picker.pickImage(
      source:
          ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _photo = File(
          picked.path,
        );
      });
    }
  }

  // ================= SAVE =================

  Future<void>
      _saveReaction() async {
    if (scenar == null ||
        record == null) {
      return;
    }

    final reaction = Reaction(
      scenarioId: record!.id,

      nazev: scenar!.nazev,

      stav: _stav,

      emoce: _vybranaEmoce,

      vzkaz:
          _vzkazCtrl.text.trim(),

      photoPath:
          _photo?.path,

      datum: DateTime.now(),
    );

    await ScenarioRecordStorage
        .addReaction(
      record!.id,
      reaction,
    );
    // ======================================================
    // RB-018
    // Synchronizace s Relationship Book
    // ======================================================

    final relationshipScenario =
        RelationshipScenarioMapper.fromScenar(scenar!);

    var chapter = await _chapterEngine.findChapterByScenario(
      relationshipScenario.scenarioId,
    );

    if (chapter == null) {
      await _chapterEngine.createChapterFromScenario(
        scenario: relationshipScenario,
      );

      chapter = await _chapterEngine.findChapterByScenario(
        relationshipScenario.scenarioId,
      );
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                PartnerReactionDetailScreen(
          reaction: reaction,
        ),
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n =
        AppLocalizations.of(context);

    _emoce = [
      l10n.emotionExcited,
      l10n.emotionCalm,
      l10n.emotionTurnedOn,
      l10n.emotionNervous,
      l10n.emotionUnsure,
      l10n.emotionThinking,
    ];

    _stavy = [
      l10n.stateWillDo,
      l10n.stateMaybeLater,
      l10n.stateWillNotDo,
    ];

    if (_vybranaEmoce.isEmpty) {
      _vybranaEmoce =
          _emoce.first;
    }

    if (_stav.isEmpty) {
      _stav = _stavy.first;
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFF12080c),

      appBar: AppBar(
        title: Text(
          l10n.openScenario,
        ),

        backgroundColor:
            const Color(
          0xFF12080c,
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),

        child:
            scenar == null
                ? _inputView(
                    l10n,
                  )
                : _readView(
                    l10n,
                  ),
      ),
    );
  }

  // ================= INPUT =================

  Widget _inputView(
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        TextField(
          controller: _codeCtrl,

          maxLines: 5,

          decoration:
              InputDecoration(
            labelText:
                l10n
                    .pasteScenarioCode,

            border:
                const OutlineInputBorder(),
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        ElevatedButton(
          onPressed: _decode,

          child: Text(
            l10n.openScenario,
          ),
        ),

        TextButton(
          onPressed: () async {
            final data =
                await Clipboard.getData(
              'text/plain',
            );

            if (data?.text !=
                null) {
              _codeCtrl.text =
                  data!.text!;
            }
          },

          child: Text(
            l10n.pasteFromClipboard,
          ),
        ),

        if (error != null)
          Padding(
            padding:
                const EdgeInsets.only(
              top: 12,
            ),

            child: Text(
              error!,

              style:
                  const TextStyle(
                color: Colors
                    .redAccent,
              ),
            ),
          ),
      ],
    );
  }

  // ================= READ =================

  Widget _readView(
    AppLocalizations l10n,
  ) {
    final s = scenar!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          Text(
            s.nazev,

            style:
                const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight
                      .bold,
              color:
                  Colors.white,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            s.text,

            style:
                const TextStyle(
              color: Colors.white,
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          Text(
            l10n.howDoYouFeel,

            style:
                const TextStyle(
              color:
                  Colors.white70,
            ),
          ),

          Wrap(
            spacing: 6,

            children:
                _emoce.map((e) {
                  return ChoiceChip(
                    label: Text(
                      e,
                    ),

                    selected:
                        e ==
                        _vybranaEmoce,

                    onSelected:
                        (_) {
                      setState(() {
                        _vybranaEmoce =
                            e;
                      });
                    },
                  );
                }).toList(),
          ),

          const SizedBox(
            height: 24,
          ),

          Text(
            l10n.howDoYouDecide,

            style:
                const TextStyle(
              color:
                  Colors.white70,
            ),
          ),

          Wrap(
            spacing: 8,

            children:
                _stavy.map((s) {
                  return ChoiceChip(
                    label: Text(
                      s,
                    ),

                    selected:
                        s == _stav,

                    onSelected:
                        (_) {
                      setState(() {
                        _stav = s;
                      });
                    },
                  );
                }).toList(),
          ),

          const SizedBox(
            height: 24,
          ),

          Text(
            l10n.message,

            style:
                const TextStyle(
              color:
                  Colors.white70,
            ),
          ),

          TextField(
            controller:
                _vzkazCtrl,

            maxLines: 3,

            decoration:
                const InputDecoration(
              filled: true,
              fillColor:
                  Color(
                0xFF1f0d14,
              ),
            ),

            style:
                const TextStyle(
              color: Colors.white,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          ElevatedButton.icon(
            onPressed:
                _pickPhoto,

            icon: const Icon(
              Icons.photo,
            ),

            label: Text(
              l10n.attachProof,
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          ElevatedButton(
            onPressed:
                _saveReaction,

            child: Text(
              l10n.sendReaction,
            ),
          ),
        ],
      ),
    );
  }
}