import 'package:flutter/material.dart';

class ReflectionCard extends StatelessWidget {
  final IconData icon;
  final String author;
  final String text;

  const ReflectionCard({
    super.key,
    required this.icon,
    required this.author,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 18,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.55,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.brown.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Icon(
                icon,
                color: Colors.brown.shade700,
              ),

              const SizedBox(width: 10),

              Text(
                author,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.brown.shade900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            text,
            style: TextStyle(
              fontSize: 17,
              height: 1.8,
              color: Colors.brown.shade900,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}