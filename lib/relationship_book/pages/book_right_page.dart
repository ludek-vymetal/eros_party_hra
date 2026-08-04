import 'dart:io';

import 'package:flutter/material.dart';

import '../models/relationship_photo.dart';
import '../models/relationship_reflection.dart';
import '../widgets/memory_block.dart';
import '../widgets/photo_frame.dart';

class BookRightPage extends StatelessWidget {
  final List<RelationshipPhoto> photos;
  final RelationshipReflection? myReflection;
  final RelationshipReflection? partnerReflection;

  final VoidCallback onAddPhoto;

  const BookRightPage({
    super.key,
    required this.photos,
    required this.myReflection,
    required this.partnerReflection,
    required this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        34,
        28,
        34,
        26,
      ),
      child: Column(
        children: [

          PhotoFrame(
            image: photos.isNotEmpty
                ? FileImage(
                    File(
                      photos.first.storagePath,
                    ),
                  )
                : null,

            onTap: onAddPhoto,
          ),

          const SizedBox(height: 18),

          Expanded(
            child: ListView(
              children: [

                if (myReflection != null)
                  MemoryBlock(
                    author: "Já",
                    text: myReflection!.text,
                  ),

                if (myReflection != null &&
                    partnerReflection != null)
                  const SizedBox(height: 12),

                if (partnerReflection != null)
                  MemoryBlock(
                    author: "Partner",
                    text: partnerReflection!.text,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              "— 2 —",
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}