import 'dart:io';
import 'package:flutter/material.dart';

import '../models/relationship_photo.dart';
import '../models/relationship_reflection.dart';
import '../widgets/memory_block.dart';
import '../widgets/photo_frame.dart';

class BookRightPage extends StatefulWidget {
  final List<RelationshipPhoto> photos;
  final RelationshipReflection? myReflection;
  final int pageNumber;
  final VoidCallback onAddPhoto;
  final VoidCallback? onAddReflection;
  final VoidCallback? onNextPage; // Callback pro přetočení na další kapitolu/stránku

  const BookRightPage({
    super.key,
    required this.photos,
    required this.myReflection,
    required this.pageNumber,
    required this.onAddPhoto,
    this.onAddReflection,
    this.onNextPage,
  });

  @override
  State<BookRightPage> createState() => _BookRightPageState();
}

class _BookRightPageState extends State<BookRightPage> {
  int _selectedPhoto = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 14, 28, 22),
      child: Column(
        children: [
          PhotoFrame(
            image: widget.photos.isNotEmpty
                ? FileImage(
                    File(widget.photos[_selectedPhoto].storagePath),
                  )
                : null,
            onTap: widget.onAddPhoto,
          ),
          if (widget.photos.length > 1) ...[
            const SizedBox(height: 3),
            SizedBox(
              height: 56,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < widget.photos.length; i++)
                      if (i != _selectedPhoto)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedPhoto = i),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.file(
                                File(widget.photos[i].storagePath),
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: widget.onAddReflection,
                    borderRadius: BorderRadius.circular(8),
                    child: MemoryBlock(
                      author: "Já",
                      text: widget.myReflection?.text ??
                          "Klepnutím sem přidej svůj vzkaz...",
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Číslo pravé stránky s reakcí na kliknutí (přetočení dopředu)
          Center(
            child: GestureDetector(
              onTap: widget.onNextPage,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "— ${widget.pageNumber} —",
                    style: TextStyle(
                      color: Colors.brown.shade800,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}