import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/relationship_photo.dart';
import '../relationship_photo_repository.dart';

class LocalRelationshipPhotoRepository
    implements RelationshipPhotoRepository {
  static final List<RelationshipPhoto> _photos = [];

  String _photosKey(String chapterId) {
    return 'relationship_book_photos_$chapterId';
  }

  // ==========================================================
  // 📥 LOAD PHOTOS
  // ==========================================================

  @override
  Future<List<RelationshipPhoto>> getPhotos(
    String chapterId,
  ) async {
    await _loadPhotosFromDisk(chapterId);

    return _photos
        .where(
          (photo) => photo.chapterId == chapterId,
        )
        .toList();
  }

  // ==========================================================
  // 💾 SAVE PHOTO
  // ==========================================================

  @override
  Future<void> savePhoto(
    RelationshipPhoto photo,
    File imageFile,
  ) async {
    final dir = await getApplicationDocumentsDirectory();

    final photoDir = Directory(
      p.join(
        dir.path,
        'relationship_book',
        photo.chapterId,
      ),
    );

    if (!photoDir.existsSync()) {
      photoDir.createSync(
        recursive: true,
      );
    }

    final newFile = await imageFile.copy(
      p.join(
        photoDir.path,
        '${photo.id}.jpg',
      ),
    );

    final savedPhoto = photo.copyWith(
      storagePath: newFile.path,
    );

    _photos.removeWhere(
      (item) => item.id == photo.id,
    );

    _photos.add(savedPhoto);

    await _savePhotosToDisk(
      photo.chapterId,
    );
  }

  // ==========================================================
  // 🗑 DELETE PHOTO
  // ==========================================================

  @override
  Future<void> deletePhoto(
    String photoId,
  ) async {
    RelationshipPhoto? photo;

    // --------------------------------------------------------
    // 1️⃣ Nejdříve zkusíme najít fotografii v cache
    // --------------------------------------------------------

    for (final item in _photos) {
      if (item.id == photoId) {
        photo = item;
        break;
      }
    }

    // --------------------------------------------------------
    // 2️⃣ Pokud není v cache, najdeme ji přímo
    //    v SharedPreferences
    // --------------------------------------------------------

    if (photo == null) {
      final prefs = await SharedPreferences.getInstance();

      final keys = prefs.getKeys();

      for (final key in keys) {
        if (!key.startsWith('relationship_book_photos_')) {
          continue;
        }

        final json = prefs.getString(key);

        if (json == null || json.isEmpty) {
          continue;
        }

        try {
          final list = jsonDecode(json) as List;

          for (final item in list) {
            final decoded =
                RelationshipPhoto.fromJson(
              Map<String, dynamic>.from(item),
            );

            if (decoded.id == photoId) {
              photo = decoded;
              break;
            }
          }
        } catch (_) {
          // Poškozený/starý záznam ignorujeme.
        }

        if (photo != null) {
          break;
        }
      }
    }

    // --------------------------------------------------------
    // 3️⃣ Fotografie skutečně neexistuje
    // --------------------------------------------------------

    if (photo == null) {
      throw StateError(
        'Fotografie s ID $photoId nebyla nalezena.',
      );
    }

    // --------------------------------------------------------
    // 4️⃣ Smazání fyzického souboru
    // --------------------------------------------------------

    final file = File(
      photo.storagePath,
    );

    if (await file.exists()) {
      await file.delete();
    }

    // --------------------------------------------------------
    // 5️⃣ Odstranění z paměťové cache
    // --------------------------------------------------------

    _photos.removeWhere(
      (item) => item.id == photo!.id,
    );

    // --------------------------------------------------------
    // 6️⃣ Odstranění ze SharedPreferences
    // --------------------------------------------------------

    await _removePhotoFromDisk(
      photo.chapterId,
      photo.id,
    );
  }

  // ==========================================================
  // 🗑 DELETE ALL PHOTOS FOR CHAPTER
  // ==========================================================

  @override
  Future<void> deletePhotosForChapter(
    String chapterId,
  ) async {
    final photos = await getPhotos(
      chapterId,
    );

    // Vytvoříme kopii seznamu,
    // protože během mazání seznam měníme.
    final photosToDelete =
        List<RelationshipPhoto>.from(photos);

    for (final photo in photosToDelete) {
      await deletePhoto(
        photo.id,
      );
    }

    // --------------------------------------------------------
    // Bezpečnostní dočištění
    // --------------------------------------------------------

    _photos.removeWhere(
      (photo) => photo.chapterId == chapterId,
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      _photosKey(chapterId),
    );

    // --------------------------------------------------------
    // Dočištění adresáře kapitoly
    // --------------------------------------------------------

    final dir =
        await getApplicationDocumentsDirectory();

    final photoDir = Directory(
      p.join(
        dir.path,
        'relationship_book',
        chapterId,
      ),
    );

    if (await photoDir.exists()) {
      await photoDir.delete(
        recursive: true,
      );
    }
  }

  // ==========================================================
  // 💾 SAVE METADATA TO SHARED PREFERENCES
  // ==========================================================

  Future<void> _savePhotosToDisk(
    String chapterId,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final jsonList = _photos
        .where(
          (photo) => photo.chapterId == chapterId,
        )
        .map(
          (photo) => photo.toJson(),
        )
        .toList();

    await prefs.setString(
      _photosKey(chapterId),
      jsonEncode(jsonList),
    );
  }

  // ==========================================================
  // 📥 LOAD METADATA FROM SHARED PREFERENCES
  // ==========================================================

  Future<void> _loadPhotosFromDisk(
    String chapterId,
  ) async {
    _photos.removeWhere(
      (photo) => photo.chapterId == chapterId,
    );

    final prefs =
        await SharedPreferences.getInstance();

    final json = prefs.getString(
      _photosKey(chapterId),
    );

    if (json == null || json.isEmpty) {
      return;
    }

    try {
      final list = jsonDecode(json) as List;

      _photos.addAll(
        list.map(
          (item) =>
              RelationshipPhoto.fromJson(
            Map<String, dynamic>.from(item),
          ),
        ),
      );
    } catch (_) {
      // Pokud je uložený JSON poškozený,
      // necháme seznam prázdný.
    }
  }

  // ==========================================================
  // 🗑 REMOVE ONE PHOTO FROM SHARED PREFERENCES
  // ==========================================================

  Future<void> _removePhotoFromDisk(
    String chapterId,
    String photoId,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final key = _photosKey(chapterId);

    final json = prefs.getString(key);

    if (json == null || json.isEmpty) {
      return;
    }

    try {
      final list = jsonDecode(json) as List;

      final remaining = list.where((item) {
        final map =
            Map<String, dynamic>.from(item);

        return map['id'] != photoId;
      }).toList();

      if (remaining.isEmpty) {
        await prefs.remove(key);
      } else {
        await prefs.setString(
          key,
          jsonEncode(remaining),
        );
      }
    } catch (_) {
      // Pokud je JSON poškozený,
      // nesmažeme náhodně ostatní data.
    }
  }
}