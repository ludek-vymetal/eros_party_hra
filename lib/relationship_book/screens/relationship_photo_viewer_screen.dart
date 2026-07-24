import 'dart:io';

import 'package:flutter/material.dart';

import '../models/relationship_photo.dart';

class RelationshipPhotoViewerScreen extends StatefulWidget {
  final List<RelationshipPhoto> photos;
  final int initialIndex;

  const RelationshipPhotoViewerScreen({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<RelationshipPhotoViewerScreen> createState() =>
      _RelationshipPhotoViewerScreenState();
}

class _RelationshipPhotoViewerScreenState
    extends State<RelationshipPhotoViewerScreen> {

  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

    _pageController = PageController(
      initialPage: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final photo = widget.photos[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          '${_currentIndex + 1} / ${widget.photos.length}',
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.photos.length,

                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },

                itemBuilder: (context, index) {

                  final photo = widget.photos[index];

                  return Center(
                    child: Hero(
                      tag: photo.id,
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 5,
                        child: Image.file(
                          File(photo.storagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (photo.description.trim().isNotEmpty)
              Container(
                width: double.infinity,
                color: Colors.black87,
                padding: const EdgeInsets.all(20),
                child: Text(
                  photo.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}