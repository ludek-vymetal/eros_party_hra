import 'dart:convert';
import 'player.dart';

class TaskBundle {
  final Gender gender;
  final int difficulty;
  final List<String> tasks;

  TaskBundle({
    required this.gender,
    required this.difficulty,
    required this.tasks,
  });

  Map<String, dynamic> toJson() => {
        'gender': gender.name,
        'difficulty': difficulty,
        'tasks': tasks,
      };

  factory TaskBundle.fromJson(Map<String, dynamic> json) {
    return TaskBundle(
      gender: Gender.values.firstWhere(
        (g) => g.name == json['gender'],
      ),
      difficulty: json['difficulty'],
      tasks: List<String>.from(json['tasks']),
    );
  }

  String toQrString() => jsonEncode(toJson());

  static TaskBundle fromQrString(String raw) {
    return TaskBundle.fromJson(jsonDecode(raw));
  }
}
