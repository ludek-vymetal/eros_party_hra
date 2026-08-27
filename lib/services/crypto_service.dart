import 'dart:convert';
import '../models/scenar.dart';

/// Kóduje/dekóduje [Scenar] do textového kódu pro QR export/import
/// mezi partnery. Jde o čisté base64 kódování dat, NE o šifrování —
/// kód je čitelný pro kohokoliv, kdo ho dekóduje. Neslouží k utajení
/// obsahu, jen k přenosu dat mimo appku (QR kód, zkopírování textu).
class ScenarCodec {
  static const _prefix = 'EROS1:';

  static String encodeScenar(Scenar scenar) {
    final jsonString = jsonEncode(scenar.toJson());
    final encoded = base64Url.encode(utf8.encode(jsonString));
    return '$_prefix$encoded';
  }

  static Scenar decodeScenar(String code) {
    if (!code.startsWith(_prefix)) {
      throw const FormatException('Neplatný kód scénáře.');
    }

    final raw = code.substring(_prefix.length);

    try {
      final decodedBytes = base64Url.decode(raw);
      final decodedString = utf8.decode(decodedBytes);
      final jsonMap = jsonDecode(decodedString) as Map<String, dynamic>;
      return Scenar.fromJson(jsonMap);
    } on FormatException {
      rethrow;
    } catch (e) {
      throw FormatException('Kód scénáře se nepodařilo přečíst: $e');
    }
  }
}

/// @deprecated Použij [ScenarCodec] — tenhle název zůstal jen kvůli
/// zpětné kompatibilitě se stávajícím voláním v `screens/`.
/// Až budou přepsaná i volající místa, tenhle alias smaž.
@Deprecated('Use ScenarCodec instead')
typedef CryptoService = ScenarCodec;