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
import '../services/cloud_partner_service.dart';

class PartnerWriteScreen extends StatefulWidget {
  final ScenarioRecord? existingRecord;
  final bool repeatScenario;

  const PartnerWriteScreen({
    super.key,
    this.existingRecord,
    this.repeatScenario = false,
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

  bool _namesLoading = true;

  bool get isEdit =>
      widget.existingRecord != null &&
      !widget.repeatScenario;

  bool shareToCommunity = false;
  bool anonymousShare = true;

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    // --------------------------------------------------------
    // PŘEDVYPLNĚNÍ EXISTUJÍCÍHO SCÉNÁŘE
    // --------------------------------------------------------

    if (widget.existingRecord != null) {
      final s =
          widget.existingRecord!.scenar;

      _autorCtrl.text = s.autor;
      _proCtrl.text = s.pro;
      _nazevCtrl.text = s.nazev;
      _cilCtrl.text = s.cil;
      _hraniceCtrl.text = s.hranice;
      _textCtrl.text = s.text;

      for (final emotion in s.emoce) {
        vybraneEmoce[emotion] = true;
      }
    }

    // --------------------------------------------------------
    // U NOVÉHO / OPAKOVANÉHO SCÉNÁŘE
    // AUTOMATICKY NAČTEME JMÉNA
    // --------------------------------------------------------

    if (!isEdit) {
      _loadAutomaticNames();
    } else {
      _namesLoading = false;
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _autorCtrl.dispose();
    _proCtrl.dispose();
    _nazevCtrl.dispose();
    _hraniceCtrl.dispose();
    _cilCtrl.dispose();
    _textCtrl.dispose();

    super.dispose();
  }

  // ==========================================================
  // AUTOMATICKÉ NAČTENÍ JMÉN
  // ==========================================================

  Future<void> _loadAutomaticNames() async {
    try {
      // ------------------------------------------------------
      // 1. MOJE JMÉNO
      // ------------------------------------------------------

      final myName =
          await CloudPartnerService
              .getMyDisplayName();

      // ------------------------------------------------------
      // 2. UID PARTNERA
      // ------------------------------------------------------

      final partnerUid =
          await CloudPartnerService
              .getPartnerUid();

      String? partnerName;

      // ------------------------------------------------------
      // 3. JMÉNO PARTNERA
      // ------------------------------------------------------

      if (partnerUid != null &&
          partnerUid.isNotEmpty) {
        partnerName =
            await CloudPartnerService
                .getUserDisplayName(
          partnerUid,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        // ----------------------------------------------------
        // AUTOR
        // ----------------------------------------------------

        if (myName != null &&
            myName.trim().isNotEmpty) {
          _autorCtrl.text =
              myName.trim();
        }

        // ----------------------------------------------------
        // PARTNER
        // ----------------------------------------------------

        if (partnerName != null &&
            partnerName.trim().isNotEmpty) {
          _proCtrl.text =
              partnerName.trim();
        }

        _namesLoading = false;
      });

      debugPrint(
        'AUTOR: ${_autorCtrl.text}',
      );

      debugPrint(
        'PRO KOHO: ${_proCtrl.text}',
      );
    } catch (e) {
      debugPrint(
        'CHYBA PRI NACITANI JMEN: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _namesLoading = false;
      });
    }
  }

  // ==========================================================
  // SAVE
  // ==========================================================

  Future<void> _save() async {
    debugPrint('SAVE START');

    final l10n =
        AppLocalizations.of(context);

    // --------------------------------------------------------
    // JMÉNA SE JEŠTĚ NAČÍTAJÍ
    // --------------------------------------------------------

    if (_namesLoading) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Ještě se načítají údaje uživatelů.',
          ),
        ),
      );

      return;
    }

    // --------------------------------------------------------
    // KONTROLA POVINNÝCH POLÍ
    // --------------------------------------------------------

    if (_autorCtrl.text.trim().isEmpty ||
        _proCtrl.text.trim().isEmpty ||
        _nazevCtrl.text.trim().isEmpty ||
        _textCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            l10n.fillRequiredFields,
          ),
        ),
      );

      return;
    }

    // --------------------------------------------------------
    // ID
    // --------------------------------------------------------

    final recordId =
        isEdit
            ? widget.existingRecord!.id
            : DateTime.now()
                .millisecondsSinceEpoch
                .toString();

    // --------------------------------------------------------
    // SCÉNÁŘ
    // --------------------------------------------------------

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

    // ========================================================
    // EDIT
    // ========================================================

    if (isEdit) {
      debugPrint('EDIT MODE');

      final updated =
          widget.existingRecord!.copyWith(
        scenar: scenar,
      );

      await ScenarioRecordStorage
          .update(updated);

      if (!mounted) {
        return;
      }

      setState(() {
        generatedCode =
            CryptoService.encodeScenar(
          scenar,
        );
      });

      return;
    }

    // ========================================================
    // NOVÝ SCÉNÁŘ
    // ========================================================

    debugPrint('NEW RECORD MODE');

    if (!widget.repeatScenario) {
      final record = ScenarioRecord(
        id: recordId,
        parentScenarioId: recordId,
        scenar: scenar,
        reactions: [],
      );

      await ScenarioRecordStorage.add(
        record,
      );
    }

    // ========================================================
    // KOMUNITA
    // ========================================================

    if (shareToCommunity) {
      await CommunityScenarioService
          .uploadScenario(
        scenar: scenar,
        anonymous: anonymousShare,
      );
    }

    // ========================================================
    // PARTNER
    // ========================================================

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

        parentScenarioId:
            widget.repeatScenario
                ? widget
                    .existingRecord!
                    .parentScenarioId
                : recordId,

        nazev: scenar.nazev,

        text: scenar.text,
      );

      debugPrint('SEND HOTOVO');
    }

    // ========================================================
    // GENEROVÁNÍ KÓDU
    // ========================================================

    if (!mounted) {
      return;
    }

    setState(() {
      generatedCode =
          CryptoService.encodeScenar(
        scenar,
      );
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

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

    // ========================================================
    // INICIALIZACE EMOCÍ
    // ========================================================

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

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ==================================================
            // AUTOR – AUTOMATICKY
            // ==================================================

            if (_namesLoading)
              const Padding(
                padding:
                    EdgeInsets.only(
                  bottom: 16,
                ),
                child: LinearProgressIndicator(),
              ),

            _automaticNameField(
              label: l10n.author,
              controller: _autorCtrl,
              icon: Icons.person,
            ),

            // ==================================================
            // PRO KOHO – AUTOMATICKY
            // ==================================================

            _automaticNameField(
              label: l10n.forWho,
              controller: _proCtrl,
              icon: Icons.favorite,
            ),

            // ==================================================
            // NÁZEV
            // ==================================================

            _field(
              l10n.scenarioTitle,
              _nazevCtrl,
            ),

            // ==================================================
            // HRANICE
            // ==================================================

            _field(
              l10n.boundaries,
              _hraniceCtrl,
            ),

            // ==================================================
            // CÍL
            // ==================================================

            _field(
              l10n.scenarioGoal,
              _cilCtrl,
            ),

            const SizedBox(
              height: 16,
            ),

            // ==================================================
            // EMOCE
            // ==================================================

            Text(
              l10n.scenarioEmotions,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Wrap(
              spacing: 8,
              runSpacing: 8,

              children:
                  emoce.map((e) {
                return FilterChip(
                  label: Text(e),

                  selected:
                      vybraneEmoce[e]!,

                  onSelected: (v) {
                    setState(() {
                      vybraneEmoce[e] =
                          v;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(
              height: 24,
            ),

            // ==================================================
            // TEXT SCÉNÁŘE
            // ==================================================

            TextField(
              controller:
                  _textCtrl,

              maxLines: 6,

              decoration:
                  InputDecoration(
                labelText:
                    l10n.scenarioText,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // KOMUNITA
            // ==================================================

            SwitchListTile(
              contentPadding:
                  EdgeInsets.zero,

              title: Text(
                l10n.shareToCommunity,
              ),

              value:
                  shareToCommunity,

              onChanged: (v) {
                setState(() {
                  shareToCommunity =
                      v;
                });
              },
            ),

            if (shareToCommunity)
              SwitchListTile(
                contentPadding:
                    EdgeInsets.zero,

                title: Text(
                  l10n.shareAnonymously,
                ),

                value:
                    anonymousShare,

                onChanged: (v) {
                  setState(() {
                    anonymousShare =
                        v;
                  });
                },
              ),

            const SizedBox(
              height: 12,
            ),

            // ==================================================
            // ULOŽIT
            // ==================================================

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed:
                    _namesLoading
                        ? null
                        : _save,

                child: Text(
                  isEdit
                      ? l10n.saveChanges
                      : l10n.generateCode,
                ),
              ),
            ),

            // ==================================================
            // VYGNEROVANÝ KÓD
            // ==================================================

            if (generatedCode != null) ...[
              const SizedBox(
                height: 20,
              ),

              SelectableText(
                generatedCode!,
              ),

              const SizedBox(
                height: 10,
              ),

              ElevatedButton(
                onPressed: () =>
                    Clipboard.setData(
                  ClipboardData(
                    text:
                        generatedCode!,
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

  // ==========================================================
  // AUTOMATICKÉ JMÉNO
  // ==========================================================

  Widget _automaticNameField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 8,
      ),

      child: TextField(
        controller: controller,

        readOnly: true,

        decoration:
            InputDecoration(
          labelText: label,

          prefixIcon: Icon(icon),

          suffixIcon:
              const Icon(
            Icons.lock_outline,
            size: 18,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BĚŽNÉ POLE
  // ==========================================================

  Widget _field(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 8,
      ),

      child: TextField(
        controller: controller,

        decoration:
            InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}