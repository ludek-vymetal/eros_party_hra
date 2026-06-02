import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';

import '../models/scenar.dart';
import '../models/scenario_record.dart';

import '../services/crypto_service.dart';
import '../services/scenario_record_storage.dart';
import '../services/community_scenario_service.dart';

import '../services/partner_link_service.dart';
import '../services/cloud_partner_scenario_service.dart';

class PartnerWriteScreen extends StatefulWidget {
  final ScenarioRecord? existingRecord;

  const PartnerWriteScreen({
    super.key,
    this.existingRecord,
  });

  @override
  State<PartnerWriteScreen> createState() =>
      _PartnerWriteScreenState();
}

class _PartnerWriteScreenState
    extends State<PartnerWriteScreen> {
  final _autorCtrl =
      TextEditingController();

  final _proCtrl =
      TextEditingController();

  final _nazevCtrl =
      TextEditingController();

  final _hraniceCtrl =
      TextEditingController();

  final _cilCtrl =
      TextEditingController();

  final _textCtrl =
      TextEditingController();

  String? generatedCode;

  late List<String> emoce;

  final Map<String, bool>
      vybraneEmoce = {};

  bool get isEdit =>
      widget.existingRecord !=
      null;

  bool shareToCommunity = false;
  bool anonymousShare = true;    

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final s =
          widget
              .existingRecord!
              .scenar;

      _autorCtrl.text = s.autor;
      _proCtrl.text = s.pro;
      _nazevCtrl.text = s.nazev;
      _cilCtrl.text = s.cil;
      _hraniceCtrl.text =
          s.hranice;
      _textCtrl.text = s.text;
    }
  }

  Future<void> _save() async {
    final l10n =
        AppLocalizations.of(context);

    if (_autorCtrl.text.isEmpty ||
        _proCtrl.text.isEmpty ||
        _nazevCtrl.text.isEmpty ||
        _textCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            l10n.fillRequiredFields,
          ),
        ),
      );

      return;
    }

    final recordId =
        isEdit
            ? widget
                .existingRecord!
                .id
            : DateTime.now()
                .millisecondsSinceEpoch
                .toString();

    final scenar = Scenar(
      id: recordId,

      autor:
          _autorCtrl.text.trim(),

      pro:
          _proCtrl.text.trim(),

      nazev:
          _nazevCtrl.text.trim(),

      cil:
          _cilCtrl.text.trim(),

      text:
          _textCtrl.text.trim(),

      hranice:
          _hraniceCtrl.text.trim(),

      emoce:
          vybraneEmoce.entries
              .where(
                (e) => e.value,
              )
              .map(
                (e) => e.key,
              )
              .toList(),

      createdAt:
          isEdit
              ? widget
                  .existingRecord!
                  .scenar
                  .createdAt
              : null,
    );

    if (isEdit) {
      final updated =
          widget
              .existingRecord!
              .copyWith(
                scenar: scenar,
              );

      await ScenarioRecordStorage
          .update(updated);

      setState(() {
        generatedCode =
            CryptoService.encodeScenar(
              scenar,
            );
      });
    
    } else {
      final record =
          ScenarioRecord(
            id: recordId,
            scenar: scenar,
            reactions: [],
          );

      await ScenarioRecordStorage
          .add(record);

      debugPrint(
        'shareToCommunity = $shareToCommunity',
      );

      if (shareToCommunity) {
        await CommunityScenarioService
            .uploadScenario(
          scenar: scenar,
          anonymous: anonymousShare,
        );
      }

      final partnerUid =
        await PartnerLinkService
            .getPartnerUid();

    debugPrint(
      'PARTNER UID: $partnerUid',
    );

    if (partnerUid != null) {
      debugPrint(
        'SENDING TO FIREBASE',
      );

      await CloudPartnerScenarioService
          .sendScenario(
        receiverUid: partnerUid,
        nazev: scenar.nazev,
        text: scenar.text,
      );

      debugPrint(
        'SENT',
      );
    }
      
      // Zde opraveno uzavření metody
      setState(() {
        generatedCode =
            CryptoService.encodeScenar(
              scenar,
            );
      
      });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n =
        AppLocalizations.of(context);

    emoce = [
      l10n.emotionTenderness,
      l10n.emotionTrust,
      l10n.emotionExcitement,
      l10n.emotionPlayfulness,
      l10n.emotionDominance,
      l10n.emotionSubmission,
      l10n.emotionRomance,
      l10n.emotionCuriosity,
    ];

    // inicializace emocí
    for (final e in emoce) {
      vybraneEmoce.putIfAbsent(
        e,
        () => false,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? l10n.editScenario
              : l10n.newScenario,
        ),
      ),

      body:
          SingleChildScrollView(
            padding:
                const EdgeInsets.all(
                  16,
                ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                _field(
                  l10n.author,
                  _autorCtrl,
                ),

                _field(
                  l10n.forWho,
                  _proCtrl,
                ),

                _field(
                  l10n
                      .scenarioTitle,
                  _nazevCtrl,
                ),

                _field(
                  l10n.boundaries,
                  _hraniceCtrl,
                ),

                _field(
                  l10n
                      .scenarioGoal,
                  _cilCtrl,
                ),

                const SizedBox(
                  height: 16,
                ),

                Text(
                  l10n
                      .scenarioEmotions,
                  style:
                      const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                ),

                Wrap(
                  spacing: 8,

                  children:
                      emoce.map((e) {
                        return FilterChip(
                          label: Text(
                            e,
                          ),

                          selected:
                              vybraneEmoce[e]!,

                          onSelected:
                              (v) {
                            setState(() {
                              vybraneEmoce[e] =
                                  v;
                            });
                          },
                        );
                      }).toList(),
                ),

                const SizedBox(
                  height: 16,
                ),

                TextField(
                  controller:
                      _textCtrl,

                  maxLines: 6,

                  decoration:
                      InputDecoration(
                        labelText:
                            l10n
                                .scenarioText,
                      ),
                ),

                const SizedBox(
                  height: 20,
                ),

                SwitchListTile(
                  title: Text(
                    l10n.shareToCommunity,
                  ),
                  value: shareToCommunity,
                  onChanged: (v) {
                    setState(() {
                      shareToCommunity = v;
                    });
                  },
                ),

                if (shareToCommunity)
                  SwitchListTile(
                    title: Text(
                      l10n.shareAnonymously,
                    ),
                    value: anonymousShare,
                    onChanged: (v) {
                      setState(() {
                        anonymousShare = v;
                      });
                    },
                  ),

                ElevatedButton(
                  onPressed: _save,

                  child: Text(
                    isEdit
                        ? l10n
                            .saveChanges
                        : l10n
                            .generateCode,
                  ),
                ),

                if (generatedCode != null) ...[
                  const SizedBox(
                    height: 12,
                  ),

                  SelectableText(
                    generatedCode!,
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  ElevatedButton(
                    onPressed: () =>
                        Clipboard.setData(
                          ClipboardData(
                            text: generatedCode!,
                          ),
                        ),
                    child: Text(
                      l10n.copyCode,
                    ),
                  ),
                ],
              ],
            ),
          ),
    );
  }

  Widget _field(
    String label,
    TextEditingController c,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
            bottom: 8,
          ),

      child: TextField(
        controller: c,

        decoration:
            InputDecoration(
              labelText: label,
            ),
      ),
    );
  }
}