import 'dart:convert';
import '../models/scenar.dart';

class CryptoService {
  static String encodeScenar(Scenar scenar) {
    final jsonString = jsonEncode(scenar.toJson());
    final encoded = base64Url.encode(utf8.encode(jsonString));
    return 'EROS1:$encoded';
  }

  static Scenar decodeScenar(String code) {
    if (!code.startsWith('EROS1:')) {
      throw Exception('Neplatný kód');
    }

    final raw = code.replaceFirst('EROS1:', '');
    final decodedBytes = base64Url.decode(raw);
    final decodedString = utf8.decode(decodedBytes);

    final jsonMap = jsonDecode(decodedString);
    return Scenar.fromJson(jsonMap);
  }
}
