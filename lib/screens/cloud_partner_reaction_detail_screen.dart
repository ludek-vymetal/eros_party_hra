import 'package:flutter/material.dart';

import '../models/cloud_partner_reaction.dart';

class CloudPartnerReactionDetailScreen
    extends StatelessWidget {
  final CloudPartnerReaction reaction;

  const CloudPartnerReactionDetailScreen({
    super.key,
    required this.reaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail reakce',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              reaction.message,
              style:
                  const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              reaction.datumFormatted,
            ),
          ],
        ),
      ),
    );
  }
}