import 'package:flutter/material.dart';

enum PhotoStorageType {
  private,
  partner,
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
      PhotoStorageType.private;

  bool _remember = true;

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text(
        'Soukromí fotografie',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Text(
            'Vyberte, kdo tuto fotografii uvidí.',
            textAlign: TextAlign.center,
          ),

          const SizedBox(
            height: 20,
          ),

          RadioListTile<PhotoStorageType>(
            value: PhotoStorageType.private,
            groupValue: _selected,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
            title: const Text(
              '🔒 Jen pro mě',
            ),
          ),

          RadioListTile<PhotoStorageType>(
            value: PhotoStorageType.partner,
            groupValue: _selected,
            onChanged: (value) {
              setState(() {
                _selected = value!;
              });
            },
            title: const Text(
              '❤️ Sdílet s partnerem',
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          CheckboxListTile(
            value: _remember,
            onChanged: (value) {
              setState(() {
                _remember = value!;
              });
            },
            title: const Text(
              'Zapamatovat tuto volbu',
            ),
            controlAffinity:
                ListTileControlAffinity.leading,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
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