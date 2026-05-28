import 'package:flutter/material.dart';

import '../models/setup_player.dart';

class PartySetupClothesScreen extends StatefulWidget {
  final SetupPlayer player;

  const PartySetupClothesScreen({
    super.key,
    required this.player,
  });

  @override
  State<PartySetupClothesScreen> createState() =>
      _PartySetupClothesScreenState();
}

class _PartySetupClothesScreenState
    extends State<PartySetupClothesScreen> {
  static const List<String> _allClothes = [
    'Trenky',
    'Podprsenka',
    'Kalhoty',
    'Boty',
    'Tričko',
    'Mikina',
    'Ponožky',
    'Kalhotky',
    'Svetr',
  ];

  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.of(widget.player.clothes);
  }

  void _toggle(String item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else {
        _selected.add(item);
      }
    });
  }

  void _confirm() {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vyber alespoň jeden kus oblečení'),
        ),
      );
      return;
    }

    widget.player.clothes = List.of(_selected);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oblečení – ${widget.player.name}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Vyber oblečení, které máš na sobě.\n'
            'První vybraný kus je speciální.',
          ),
          const SizedBox(height: 16),
          for (final item in _allClothes)
            CheckboxListTile(
              title: Text(item),
              value: _selected.contains(item),
              onChanged: (_) => _toggle(item),
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _confirm,
            child: const Text('Potvrdit'),
          ),
        ],
      ),
    );
  }
}
