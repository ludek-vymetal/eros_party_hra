import 'dart:math';

import '../data/eros_whispers.dart';
import '../models/eros_whisper.dart';

class ErosWhisperService {

  static final Random _random = Random();

  static ErosWhisper random(
      WhisperCategory category,
      ) {

    final list = erosWhispers
        .where((e) => e.category == category)
        .toList();

    return list[_random.nextInt(list.length)];
  }

  static ErosWhisper byId(int id) {
    return erosWhispers.firstWhere((e) => e.id == id);
  }
}