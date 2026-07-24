import 'dart:convert';

/// Pro koho je úkol určen
enum TaskTarget {
  male,
  female,
  all,
}

/// Jeden herní úkol
class Task {
  final String id;          // unikátní ID (pro editaci / mazání)
  String text;              // text úkolu
  int difficulty;           // 1–3
  TaskTarget target;        // muž / žena / všichni

  Task({
    required this.id,
    required this.text,
    required this.difficulty,
    required this.target,
  });

  // =========================
  // SERIALIZACE
  // =========================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'difficulty': difficulty,
      'target': target.name,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      text: json['text'],
      difficulty: json['difficulty'],
      target: TaskTarget.values.firstWhere(
        (t) => t.name == json['target'],
      ),
    );
  }

  // =========================
  // QR / SDÍLENÍ
  // =========================

  /// Převod úkolu na JSON string (pro QR)
  String toQrString() {
    return jsonEncode(toJson());
  }

  /// Načtení úkolu z QR JSON stringu
  static Task fromQrString(String qr) {
    final data = jsonDecode(qr) as Map<String, dynamic>;
    return Task.fromJson(data);
  }
}