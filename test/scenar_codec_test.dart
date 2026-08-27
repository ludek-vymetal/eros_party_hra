import 'package:flutter_test/flutter_test.dart';

import 'package:eros_party_hra/models/scenar.dart';
import 'package:eros_party_hra/services/crypto_service.dart';

void main() {
  group('ScenarCodec', () {
    test('encode → decode vrátí scénář se stejnými daty (round-trip)', () {
      final original = Scenar(
        id: 'test-id-1',
        autor: 'Anna',
        pro: 'Petr',
        nazev: 'Testovací scénář',
        cil: 'Ověřit round-trip kódování',
        text: 'Nějaký text scénáře s háčky a čárkami: řšťžýáíé',
        hranice: 'Žádné explicitní hranice v testu',
        emoce: const ['radost', 'napětí'],
        ocekavanaReakce: const ['úsměv'],
        createdAt: DateTime.utc(2026, 1, 15, 10, 30),
        archived: false,
      );

      final code = ScenarCodec.encodeScenar(original);
      final decoded = ScenarCodec.decodeScenar(code);

      expect(decoded.id, original.id);
      expect(decoded.autor, original.autor);
      expect(decoded.pro, original.pro);
      expect(decoded.nazev, original.nazev);
      expect(decoded.cil, original.cil);
      expect(decoded.text, original.text);
      expect(decoded.hranice, original.hranice);
      expect(decoded.emoce, original.emoce);
      expect(decoded.ocekavanaReakce, original.ocekavanaReakce);
      expect(decoded.createdAt, original.createdAt);
      expect(decoded.archived, original.archived);
    });

    test('vygenerovaný kód začíná prefixem EROS1:', () {
      final scenar = Scenar(
        id: 'id', autor: 'A', pro: 'B', nazev: 'N',
        cil: 'C', text: 'T', hranice: 'H', emoce: const [],
      );
      final code = ScenarCodec.encodeScenar(scenar);
      expect(code.startsWith('EROS1:'), isTrue);
    });

    test('decode vyhodí FormatException, když kód nemá platný prefix', () {
      expect(
        () => ScenarCodec.decodeScenar('NECO_JINEHO:abc123'),
        throwsFormatException,
      );
    });

    test('decode vyhodí FormatException na poškozený/nevalidní obsah', () {
      expect(
        () => ScenarCodec.decodeScenar('EROS1:!!!not-valid-base64!!!'),
        throwsFormatException,
      );
    });

    test('deprecated alias CryptoService pořád funguje (zpětná kompatibilita)', () {
      final scenar = Scenar(
        id: 'id2', autor: 'A', pro: 'B', nazev: 'N',
        cil: 'C', text: 'T', hranice: 'H', emoce: const [],
      );
      // ignore: deprecated_member_use_from_same_package
      final code = CryptoService.encodeScenar(scenar);
      // ignore: deprecated_member_use_from_same_package
      final decoded = CryptoService.decodeScenar(code);
      expect(decoded.id, scenar.id);
    });
  });
}