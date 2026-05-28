import 'dart:convert';
import 'dart:math';

import '../models/player.dart';

class TaskBank {
  final Map<Gender, Map<int, List<String>>> tasks;

  final Random _random = Random();

  TaskBank({
    required this.tasks,
  });

  // 🎲 Náhodný úkol pro hru
  String getRandomTask(
    Gender gender,
    int difficulty,
  ) {
    final list = tasks[gender]?[difficulty];

    if (list == null || list.isEmpty) {
      return 'Žádné úkoly nejsou k dispozici';
    }

    return list[_random.nextInt(list.length)];
  }

  // ➕ Přidat úkol
  void addTask(
    Gender gender,
    int difficulty,
    String text,
  ) {
    tasks.putIfAbsent(gender, () => {});

    tasks[gender]!.putIfAbsent(
      difficulty,
      () => [],
    );

    tasks[gender]![difficulty]!.add(text);
  }

  // ✏️ Upravit úkol
  void updateTask(
    Gender gender,
    int difficulty,
    int index,
    String newText,
  ) {
    tasks[gender]?[difficulty]?[index] = newText;
  }

  // 🗑️ Smazat úkol
  void removeTask(
    Gender gender,
    int difficulty,
    int index,
  ) {
    tasks[gender]?[difficulty]?.removeAt(index);
  }

  // 📦 Map pro ukládání
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    for (final gender in tasks.keys) {
      final genderKey =
          gender == Gender.male ? '1' : '2';

      data[genderKey] = {};

      for (final diff in tasks[gender]!.keys) {
        data[genderKey][diff.toString()] =
            tasks[gender]![diff];
      }
    }

    return data;
  }

  // 💾 Uložení do JSON String
  String toJsonString() {
    return const JsonEncoder.withIndent(
      '  ',
    ).convert(toJson());
  }

  // 🔽 Načtení z JSON String
  factory TaskBank.fromJsonString(
    String jsonString,
  ) {
    final Map<String, dynamic> data =
        json.decode(jsonString);

    return TaskBank.fromJson(data);
  }

  // 🔽 Načtení z Map
  factory TaskBank.fromJson(
    Map<String, dynamic> data,
  ) {
    final Map<Gender, Map<int, List<String>>>
        result = {};

    for (final entry in data.entries) {
      // 🔥 IGNORUJ BONUS SEKCI
      if (entry.key == 'bonus') continue;

      final gender =
          entry.key == '1'
              ? Gender.male
              : Gender.female;

      result[gender] = {};

      final diffs =
          entry.value as Map<String, dynamic>;

      for (final d in diffs.entries) {
        final diff = int.tryParse(d.key);

        if (diff == null) continue;

        result[gender]![diff] =
            (d.value as List).cast<String>();
      }
    }

    return TaskBank(tasks: result);
  }
}