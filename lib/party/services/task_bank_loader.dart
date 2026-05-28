import 'package:flutter/services.dart';

import 'task_bank.dart';
import 'task_bank_storage.dart';

class TaskBankLoader {
  static Future<TaskBank> load() async {
    try {
      // 1️⃣ ZKUS NAČÍST ZE STORAGE (SharedPreferences)
      final stored = await TaskBankStorage.load();

      if (stored != null &&
          stored.tasks.isNotEmpty) {
        return stored;
      }

      // 2️⃣ FALLBACK – NAČTENÍ Z ASSETS
      final json = await rootBundle.loadString(
        'assets/banka_ukolu.json',
      );

      final bank =
          TaskBank.fromJsonString(json);

      // 3️⃣ ULOŽ JAKO VÝCHOZÍ BANKU
      await TaskBankStorage.save(bank);

      return bank;
    } catch (e) {
      // ⛔ KRITICKÉ:
      // nikdy NEVRACET prázdnou banku
      rethrow;
    }
  }
}