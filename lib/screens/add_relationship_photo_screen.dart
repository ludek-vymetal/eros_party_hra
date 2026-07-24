import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../relationship_book/models/relationship_photo.dart';
import '../relationship_book/repositories/local/local_relationship_photo_repository.dart';
import '../relationship_book/services/relationship_photo_service.dart';
import '../relationship_book/services/partner_service.dart';

class AddRelationshipPhotoScreen extends StatefulWidget {
  final String chapterId;

  const AddRelationshipPhotoScreen({
    super.key,
    required this.chapterId,
  });

  @override
  State<AddRelationshipPhotoScreen> createState() =>
      _AddRelationshipPhotoScreenState();
}

class _AddRelationshipPhotoScreenState
    extends State<AddRelationshipPhotoScreen> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _descriptionController =
      TextEditingController();

  bool _sharedWithPartner = false;

  final RelationshipPhotoService _photoService =
      RelationshipPhotoService(
    repository: LocalRelationshipPhotoRepository(),
  );

  File? _image;

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (file == null) {
      return;
    }

    setState(() {
      _image = File(file.path);
    });
  }

  Future<void> _save() async {
    debugPrint("SAVE START");

    if (!PartnerService.isReady) {
      return;
    }

    final photo = RelationshipPhoto(
      id: const Uuid().v4(),
      chapterId: widget.chapterId,
      authorId: PartnerService.currentUid!,
      storagePath: _image!.path,
      downloadUrl: '',
      description: _descriptionController.text.trim(),
      createdAt: DateTime.now(),
      sharedWithPartner: _sharedWithPartner,
    );

    debugPrint("CALL SERVICE");

    await _photoService.savePhoto(
      photo,
      _image!,
    );

    debugPrint("SERVICE DONE");

    if (!mounted) {
      return;
    }

    Navigator.pop(
      context,
      true,
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add photo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: _image == null
                  ? const Center(
                      child: Text(
                        'No photo selected',
                      ),
                    )
                  : ClipRRect(
                      borderRadius:
                          BorderRadius.circular(16),
                      child: Image.file(
                        _image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller:
                  _descriptionController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Description (optional)',
                border:
                    OutlineInputBorder(),
                   ),
              ),
            const SizedBox(
              height: 20,
            ),

            const Text(
              'Komu bude tato vzpomínka patřit?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            RadioListTile<bool>(
              value: false,
              groupValue: _sharedWithPartner,
              onChanged: (value) {
                setState(() {
                  _sharedWithPartner = value!;
                });
              },
              title: const Text(
                '🔒 Jen moje',
              ),
            ),

            RadioListTile<bool>(
              value: true,
              groupValue: _sharedWithPartner,
              onChanged: (value) {
                setState(() {
                  _sharedWithPartner = value!;
                });
              },
              title: const Text(
                '❤️ Naše společná',
              ),
            ),

            const SizedBox(
              height: 20,
            ),        
            
            FilledButton.icon(
              onPressed: _pickImage,
              icon: const Icon(
                Icons.photo_library,
              ),
              label: const Text(
                'Choose photo',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            FilledButton(
              onPressed: _save,
              child: const Text(
                'Save',
              ),
            ),
          ],
        ),
      ),
    );
  }
}