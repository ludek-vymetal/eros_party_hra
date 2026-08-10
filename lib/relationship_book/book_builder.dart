import 'package:flutter/material.dart';

import 'models/relationship_chapter.dart';
import 'models/relationship_photo.dart';
import 'models/relationship_reflection.dart';
import 'pages/book_left_page.dart';
import 'pages/book_right_page.dart';
import 'widgets/open_book.dart';

class BookBuilder {
  static List<Widget> build({
    required List<RelationshipChapter> chapters,
    required List<RelationshipPhoto> photos,
    required RelationshipReflection? myReflection,
    required RelationshipReflection? partnerReflection,
    required PageController pageController,
    required Future<void> Function(String chapterId) onAddPhoto,
    required Future<void> Function(String chapterId) onAddReflection,
  }) {
    return List.generate(
      chapters.length,
      (index) {
        final chapter = chapters[index];
        final chapterPhotos = photos
            .where((photo) => photo.chapterId == chapter.id)
            .toList();

        final leftNumber = (index * 2) + 1;
        final rightNumber = (index * 2) + 2;

        void goToPrevious() {
          if (pageController.hasClients && index > 0) {
            pageController.previousPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        }

        void goToNext() {
          if (pageController.hasClients && index < chapters.length - 1) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        }

        return OpenBook(
          leftPageNumber: leftNumber,
          rightPageNumber: rightNumber,
          onPrevious: goToPrevious,
          onNext: goToNext,
          leftPage: BookLeftPage(
            chapter: chapter,
            chapterNumber: index + 1,
            pageNumber: leftNumber,
            motto: chapter.customMotto ?? chapter.motto,
            partnerReflection: partnerReflection,
            onPreviousPage: goToPrevious,
          ),
          rightPage: BookRightPage(
            photos: chapterPhotos.isNotEmpty ? chapterPhotos : photos,
            myReflection: myReflection,
            pageNumber: rightNumber,
            onAddPhoto: () => onAddPhoto(chapter.id),
            onAddReflection: () => onAddReflection(chapter.id),
            onNextPage: goToNext,
          ),
        );
      },
    );
  }
}