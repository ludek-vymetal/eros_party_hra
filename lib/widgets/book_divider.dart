import 'package:flutter/material.dart';

class BookDivider extends StatelessWidget {
  final IconData icon;

  const BookDivider({
    super.key,
    this.icon = Icons.auto_awesome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: Colors.brown,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              icon,
              color: Colors.brown,
              size: 18,
            ),
          ),
          const Expanded(
            child: Divider(
              color: Colors.brown,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}