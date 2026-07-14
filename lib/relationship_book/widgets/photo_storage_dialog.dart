import 'package:flutter/material.dart';

enum PhotoStorageType {
  local,
  cloud,
}

class PhotoStorageDialog
    extends StatefulWidget {
  const PhotoStorageDialog({
    super.key,
  });

  @override
  State<PhotoStorageDialog> createState() =>
      _PhotoStorageDialogState();
}

class _PhotoStorageDialogState
    extends State<PhotoStorageDialog> {
  PhotoStorageType _selected =
      PhotoStorageType.cloud;

  bool _remember = true;

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text(
        'Ukládání fotografií',
      ),
      content: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          const Text(
            'Vyberte způsob ukládání fotografií.',
          ),

          const SizedBox(height: 20),

          RadioListTile(
            value:
                PhotoStorageType.cloud,
            groupValue:
                _selected,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
            title: const Text(
              'Synchronizovat do cloudu',
            ),
          ),

          RadioListTile(
            value:
                PhotoStorageType.local,
            groupValue:
                _selected,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
            title: const Text(
              'Pouze v tomto zařízení',
            ),
          ),

          CheckboxListTile(
            value: _remember,
            onChanged: (value) {
              setState(() {
                _remember = value!;
              });
            },
            title: const Text(
              'Zapamatovat volbu',
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              (
                _selected,
                _remember,
              ),
            );
          },
          child: const Text(
            'Pokračovat',
          ),
        ),
      ],
    );
  }
}