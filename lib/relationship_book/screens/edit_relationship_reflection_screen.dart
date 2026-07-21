import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/relationship_reflection.dart';
import '../services/permission_service.dart';

class EditRelationshipReflectionScreen extends StatefulWidget {
  final RelationshipReflection? reflection;
  final String chapterId;
  final String authorId;

  const EditRelationshipReflectionScreen({
    super.key,
    required this.chapterId,
    required this.authorId,
    this.reflection,
  });

  @override
  State<EditRelationshipReflectionScreen> createState() =>
      _EditRelationshipReflectionScreenState();
}

class _EditRelationshipReflectionScreenState
    extends State<EditRelationshipReflectionScreen> {

  final TextEditingController _controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.reflection != null) {
      _controller.text = widget.reflection!.text;
    }
  }

  Future<void> _save() async {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    final reflection = RelationshipReflection(
      id: widget.reflection?.id ??
          const Uuid().v4(),
      chapterId:
          widget.reflection?.chapterId ??
          widget.chapterId,
      authorId:
          widget.reflection?.authorId ??
          widget.authorId,
      text: _controller.text.trim(),
      createdAt:
          widget.reflection?.createdAt ??
              DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(
      context,
      reflection,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final canEdit =
        widget.reflection == null ||
        PermissionService.canEditReflection(
          widget.reflection!,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reflection',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            if (!canEdit)
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
                child: Text(
                  '❤️ Tuto reflexi napsal váš partner. Je pouze ke čtení.',
                  textAlign: TextAlign.center,
                ),
              ),

            Expanded(
              child: TextField(
                controller: _controller,
                enabled: canEdit,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText:
                      'Write your memory...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            if (canEdit)
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