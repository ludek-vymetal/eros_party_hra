import 'package:flutter/material.dart';

import '../models/relationship_event.dart';

class EventTile extends StatelessWidget {
  final RelationshipEvent event;

  const EventTile({
    super.key,
    required this.event,
  });

  IconData get _icon {
    switch (event.type) {
      case RelationshipEventType.chapterCreated:
        return Icons.menu_book;

      case RelationshipEventType.scenarioAccepted:
        return Icons.favorite;

      case RelationshipEventType.scenarioRejected:
        return Icons.cancel;

      case RelationshipEventType.scenarioCompleted:
        return Icons.check_circle;

      case RelationshipEventType.noteAdded:
        return Icons.edit_note;

      case RelationshipEventType.photoAdded:
        return Icons.photo;

      case RelationshipEventType.videoAdded:
        return Icons.videocam;

      case RelationshipEventType.voiceAdded:
        return Icons.mic;

      case RelationshipEventType.chapterEdited:
        return Icons.edit;
    }
  }

  Color get _iconColor {
    switch (event.type) {
      case RelationshipEventType.chapterCreated:
        return Colors.brown;

      case RelationshipEventType.scenarioAccepted:
        return Colors.green;

      case RelationshipEventType.scenarioRejected:
        return Colors.red;

      case RelationshipEventType.scenarioCompleted:
        return Colors.blue;

      case RelationshipEventType.noteAdded:
        return Colors.orange;

      case RelationshipEventType.photoAdded:
        return Colors.purple;

      case RelationshipEventType.videoAdded:
        return Colors.deepPurple;

      case RelationshipEventType.voiceAdded:
        return Colors.teal;

      case RelationshipEventType.chapterEdited:
        return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          _icon,
          color: _iconColor,
        ),
        title: Text(event.description),
        subtitle: Text(
          event.createdAt.toLocal().toString(),
        ),
      ),
    );
  }
}