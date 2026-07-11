import 'dart:math';

import '../data/eros_voice.dart';
import '../models/eros_voice.dart';

class ErosVoiceService {

  static final Random _random = Random();

  static ErosVoice random(ErosVoiceCategory category) {

    final list = erosVoices
        .where((e) => e.category == category)
        .toList();

    return list[_random.nextInt(list.length)];
  }

  static ErosVoice byId(int id) {
    return erosVoices.firstWhere((e) => e.id == id);
  }
}