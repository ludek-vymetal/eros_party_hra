import 'dart:io';

import 'package:flutter/material.dart';

import '../models/relationship_photo.dart';
import '../models/relationship_reflection.dart';
import '../repositories/local/local_relationship_photo_repository.dart';
import '../services/relationship_photo_service.dart';
import '../widgets/memory_block.dart';
import '../widgets/photo_frame.dart';

class BookRightPage extends StatefulWidget {
  final List<RelationshipPhoto> photos;
  final RelationshipReflection? myReflection;
  final int pageNumber;

  final VoidCallback onAddPhoto;
  final VoidCallback? onAddReflection;
  final VoidCallback? onNextPage;

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
  State<BookRightPage> createState() =>
      _BookRightPageState();
}

class _BookRightPageState
    extends State<BookRightPage> {

  int _selectedPhoto = 0;

  late final RelationshipPhotoService
      _photoService;

  @override
  void initState() {
    super.initState();

    _photoService =
        RelationshipPhotoService(
      repository:
          LocalRelationshipPhotoRepository(),
    );
  }

  // ==========================================================
  // SMAZÁNÍ FOTOGRAFIE
  // ==========================================================

  Future<void>
      _deleteSelectedPhoto() async {

    if (widget.photos.isEmpty) {
      return;
    }

    if (_selectedPhoto < 0 ||
        _selectedPhoto >=
            widget.photos.length) {
      return;
    }

    final photo =
        widget.photos[_selectedPhoto];

    final confirmed =
        await showDialog<bool>(
      context: context,

      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          title:
              const Text(
            'Smazat fotografii?',
          ),

          content:
              const Text(
            'Tato fotografie bude odstraněna z této vzpomínky.\n\n'
            'Tuto akci již nelze vrátit zpět.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },

              child:
                  const Text(
                'Zrušit',
              ),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },

              child:
                  const Text(
                'Smazat',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _photoService.deletePhoto(
        photo.id,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        widget.photos.removeWhere(
          (item) =>
              item.id == photo.id,
        );

        if (widget.photos.isEmpty) {
          _selectedPhoto = 0;
          return;
        }

        if (_selectedPhoto >=
            widget.photos.length) {
          _selectedPhoto =
              widget.photos.length - 1;
        }
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Fotografie byla odstraněna.',
          ),
          duration:
              Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Fotografii se nepodařilo odstranit.',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final hasPhotos =
        widget.photos.isNotEmpty;

    final safeSelectedPhoto =
        hasPhotos
            ? _selectedPhoto.clamp(
                0,
                widget.photos.length - 1,
              )
            : 0;

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final width =
            constraints.maxWidth;

        final height =
            constraints.maxHeight;

        return Padding(
          padding:
              EdgeInsets.fromLTRB(
            width * 0.095,
            height * 0.025,
            width * 0.095,
            height * 0.035,
          ),

          child: Column(
            children: [

              // ==================================================
              // HLAVNÍ FOTOGRAFIE
              // ==================================================

              SizedBox(
                width:
                    double.infinity,

                child: PhotoFrame(
                  image: hasPhotos
                      ? FileImage(
                          File(
                            widget
                                .photos[
                                    safeSelectedPhoto]
                                .storagePath,
                          ),
                        )
                      : null,

                  onTap:
                      widget.onAddPhoto,

                  onDelete:
                      hasPhotos
                          ? _deleteSelectedPhoto
                          : null,
                ),
              ),

              // ==================================================
              // OSTATNÍ FOTOGRAFIE
              // ==================================================

              if (widget.photos.length > 1) ...[
                const SizedBox(
                  height: 4,
                ),

                SizedBox(
                  height: 48,

                  child:
                      SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal,

                    child: Row(
                      children: [
                        for (
                          int i = 0;
                          i <
                              widget
                                  .photos
                                  .length;
                          i++
                        )

                          if (
                              i !=
                                  safeSelectedPhoto)

                            Padding(
                              padding:
                                  const EdgeInsets.only(
                                right: 5,
                              ),

                              child:
                                  GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPhoto =
                                        i;
                                  });
                                },

                                child:
                                    ClipRRect(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    5,
                                  ),

                                  child:
                                      Image.file(
                                    File(
                                      widget
                                          .photos[
                                              i]
                                          .storagePath,
                                    ),

                                    width:
                                        48,

                                    height:
                                        48,

                                    fit:
                                        BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(
                height:
                    height * 0.018,
              ),

              // ==================================================
              // REFLEXE
              // ==================================================

              Expanded(
                child:
                    SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),

                  child:
                      InkWell(
                    onTap:
                        widget.onAddReflection,

                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),

                    child:
                        MemoryBlock(
                      author:
                          'Já',

                      text:
                          widget.myReflection
                                  ?.text ??
                              'Klepnutím sem přidej svůj vzkaz...',
                    ),
                  ),
                ),
              ),

              SizedBox(
                height:
                    height * 0.018,
              ),

              // ==================================================
              // ČÍSLO STRÁNKY
              // ==================================================

              Center(
                child: GestureDetector(
                  onTap:
                      widget.onNextPage,

                  child: MouseRegion(
                    cursor:
                        SystemMouseCursors.click,

                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        4,
                      ),

                      child: Text(
                        '— ${widget.pageNumber} —',

                        style:
                            TextStyle(
                          color:
                              const Color(
                            0xFF5D4037,
                          ),

                          fontSize:
                              width * 0.050,

                          fontStyle:
                              FontStyle.italic,

                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}