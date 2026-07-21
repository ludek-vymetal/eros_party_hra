import 'package:flutter/material.dart';

enum PhotoStorageType {
  local,
  cloud,
  both,
}

class PhotoStorageDialog extends StatefulWidget {
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
      PhotoStorageType.both;

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
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Vyberte způsob ukládání fotografií.',
          ),

          const SizedBox(height: 20),

          RadioListTile<PhotoStorageType>(
            value: PhotoStorageType.both,
            groupValue: _selected,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
            title: const Text(
              'Lokálně + Cloud (doporučeno)',
            ),
          ),

          RadioListTile<PhotoStorageType>(
            value: PhotoStorageType.cloud,
            groupValue: _selected,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
            title: const Text(
              'Pouze Cloud',
            ),
          ),

          RadioListTile<PhotoStorageType>(
            value: PhotoStorageType.local,
            groupValue: _selected,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
            title: const Text(
              'Pouze toto zařízení',
            ),
          ),

          const SizedBox(height: 10),

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
            controlAffinity:
                ListTileControlAffinity.leading,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Zrušit',
          ),
        ),
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