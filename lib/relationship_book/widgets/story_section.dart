import 'package:flutter/material.dart';

class StorySection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const StorySection({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Icon(
                icon,
                color: Colors.brown.shade700,
                size: 28,
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.55,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.brown.shade200,
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}