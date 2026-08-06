import 'package:flutter/material.dart';

import 'models/relationship_chapter.dart';
import 'models/relationship_reflection.dart';
import 'models/relationship_photo.dart';

import 'widgets/open_book.dart';

import 'pages/book_left_page.dart';
import 'pages/book_right_page.dart';

class BookBuilder {
  static List<Widget> build({
    required List<RelationshipChapter> chapters,
    required List<RelationshipPhoto> photos,
    required RelationshipReflection? myReflection,
    required RelationshipReflection? partnerReflection,
    required Future<void> Function(String chapterId) onAddPhoto,
  }) {
    return List.generate(
      chapters.length,
      (index) {
        final chapter = chapters[index];

        return OpenBook(
          leftPage: BookLeftPage(
            chapter: chapter,
            chapterNumber: index + 1,
            motto: chapter.customMotto,
          ),
          rightPage: BookRightPage(
            photos: photos,
            myReflection: myReflection,
            partnerReflection: partnerReflection,
            onAddPhoto: () => onAddPhoto(chapter.id),
          ),
        );
      },
    );
  }
}