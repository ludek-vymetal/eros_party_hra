import 'dart:convert';
import '../models/player.dart';

class TaskQrPackage {
  final Gender gender;
  final int difficulty;
  final List<String> tasks;

  TaskQrPackage({
    required this.gender,
    required this.difficulty,
    required this.tasks,
  });

  String toJsonString() {
    return jsonEncode({
      'gender': gender.name,
      'difficulty': difficulty,
      'tasks': tasks,
    });
  }

  factory TaskQrPackage.fromJsonString(String raw) {
    final Map<String, dynamic> json = jsonDecode(raw);

    return TaskQrPackage(
      gender: json['gender'] == 'male'
          ? Gender.male
          : Gender.female,
      difficulty: json['difficulty'],
      tasks: (json['tasks'] as List).cast<String>(),
    );
  }
}
