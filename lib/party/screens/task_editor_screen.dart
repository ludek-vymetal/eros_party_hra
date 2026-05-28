import 'package:flutter/material.dart';

class TaskEditorScreen extends StatefulWidget {
  final String? initialText;

  const TaskEditorScreen({
    super.key,
    this.initialText,
  });

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialText ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialText != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Upravit úkol' : 'Přidat úkol'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final text = _controller.text.trim();
              if (text.isEmpty) return;
              Navigator.pop(context, text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          maxLines: null,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Zadej text úkolu…',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
