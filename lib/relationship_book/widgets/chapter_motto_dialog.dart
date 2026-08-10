import 'dart:math';
import 'package:flutter/material.dart';

class ChapterMottoDialog extends StatefulWidget {
  final String? initialMotto;

  const ChapterMottoDialog({
    super.key,
    this.initialMotto,
  });

  @override
  State<ChapterMottoDialog> createState() => _ChapterMottoDialogState();
}

class _ChapterMottoDialogState extends State<ChapterMottoDialog> {
  static const List<String> _mottoPresets = [
    '„Tak co... čím ho nebo ji překvapíš příště?“',
    '„Láska není o hledání někoho, s kým lze žít, ale bez koho žít nelze.“',
    '„Příběhy, které píšeme společně, jsou ty nejkrásnější.“',
    '„Každý moment s tebou je novým začátkem.“',
    '„Nezáleží na tom, kam jdeš, ale s kým jdeš.“',
  ];

  late String _currentMotto;
  final TextEditingController _customController = TextEditingController();
  bool _isEditingCustom = false;

  @override
  void initState() {
    super.initState();
    _currentMotto = widget.initialMotto ?? _mottoPresets.first;
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _nextRandomMotto() {
    final random = Random();
    String newMotto;
    do {
      newMotto = _mottoPresets[random.nextInt(_mottoPresets.length)];
    } while (newMotto == _currentMotto && _mottoPresets.length > 1);

    setState(() {
      _currentMotto = newMotto;
      _isEditingCustom = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F3E8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: Colors.brown.shade700,
                size: 38,
              ),
              const SizedBox(height: 16),
              Text(
                'Motto kapitoly',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade900,
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.brown.shade300),
              const SizedBox(height: 24),
              if (_isEditingCustom)
                TextField(
                  controller: _customController,
                  maxLines: 3,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown.shade900,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Napište vlastní motto...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              else
                Text(
                  _currentMotto,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                    color: Colors.brown.shade700,
                  ),
                ),
              const SizedBox(height: 24),
              Divider(color: Colors.brown.shade300),
              const SizedBox(height: 20),
              Text(
                'Vyberte větu, která bude provázet tuto kapitolu vašeho příběhu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.brown.shade600,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _nextRandomMotto,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Jiné motto'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditingCustom = !_isEditingCustom;
                      if (_isEditingCustom) {
                        _customController.text =
                            _currentMotto.replaceAll('„', '').replaceAll('“', '');
                      }
                    });
                  },
                  icon: Icon(_isEditingCustom ? Icons.close : Icons.edit),
                  label: Text(_isEditingCustom ? 'Zrušit úpravu' : 'Vlastní motto'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    final result = _isEditingCustom
                        ? '„${_customController.text.trim()}“'
                        : _currentMotto;
                    Navigator.pop(context, result);
                  },
                  icon: const Icon(Icons.favorite),
                  label: const Text('Použít'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Zavřít'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}