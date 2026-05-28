import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TaskQrExportScreen extends StatelessWidget {
  final String qrData;

  const TaskQrExportScreen({
    super.key,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sdílet úkoly')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '📲 Naskenuj QR kód',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: qrData,
              size: 280,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Úkoly se přidají do hry',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
