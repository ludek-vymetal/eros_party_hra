import 'package:flutter/material.dart';

class RightPage extends StatelessWidget {
  final Widget photo;
  final String myMemory;
  final String partnerMemory;

  const RightPage({
    super.key,
    required this.photo,
    required this.myMemory,
    required this.partnerMemory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: photo,
          ),
        ),

        const SizedBox(height: 30),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.brown.shade200,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(myMemory),
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.brown.shade200,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(partnerMemory),
        ),
      ],
    );
  }
}