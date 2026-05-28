import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/task_qr_package.dart';
import '../services/task_bank_loader.dart';
import '../services/task_bank_storage.dart';

class TaskQrImportScreen extends StatefulWidget {
  const TaskQrImportScreen({
    super.key,
  });

  @override
  State<TaskQrImportScreen> createState() =>
      _TaskQrImportScreenState();
}

class _TaskQrImportScreenState
    extends State<TaskQrImportScreen> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Import úkolů z QR',
        ),
      ),
      body: MobileScanner(
        onDetect:
            (BarcodeCapture capture) async {
          if (_handled) return;

          final navigator =
              Navigator.of(context);

          final messenger =
              ScaffoldMessenger.of(context);

          final List<Barcode> barcodes =
              capture.barcodes;

          if (barcodes.isEmpty) return;

          final String? raw =
              barcodes.first.rawValue;

          if (raw == null ||
              raw.isEmpty) {
            return;
          }

          _handled = true;

          try {
            final package =
                TaskQrPackage
                    .fromJsonString(raw);

            final bank =
                await TaskBankLoader.load();

            for (final task
                in package.tasks) {
              bank.addTask(
                package.gender,
                package.difficulty,
                task,
              );
            }

            await TaskBankStorage.save(
              bank,
            );

            if (!mounted) return;

            messenger.showSnackBar(
              const SnackBar(
                content: Text(
                  '✅ Úkoly úspěšně importovány',
                ),
              ),
            );

            navigator.pop();
          } catch (e) {
            _handled = false;

            if (!mounted) return;

            messenger.showSnackBar(
              const SnackBar(
                content: Text(
                  '❌ Neplatný QR kód',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}