import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TaskQrExportScreen extends StatelessWidget {
  final String data;

  const TaskQrExportScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR export úkolů')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: data,
              size: 260,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'Naskenuj QR kód\nnebo ho pošli kamarádům',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
