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

  String _photosKey(
    String chapterId,
  ) =>
      'relationship_book_photos_$chapterId';

  @override
  Future<List<RelationshipPhoto>> getPhotos(
    String chapterId,
  ) async {

    await _loadPhotosFromDisk(
      chapterId,
    );

    return _photos
        .where(
          (photo) => photo.chapterId == chapterId,
        )
        .toList();
  }

  @override
  Future<void> savePhoto(
    RelationshipPhoto photo,
    File imageFile,
  ) async {

    final dir =
        await getApplicationDocumentsDirectory();

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

    _photos.add(
      savedPhoto,
    );

    await _savePhotosToDisk(
      photo.chapterId,
    );
  }

  @override
  Future<void> deletePhoto(
    String photoId,
  ) async {

    final photo = _photos.firstWhere(
      (e) => e.id == photoId,
    );

    final file = File(
      photo.storagePath,
    );

    if (await file.exists()) {
      await file.delete();
    }

    _photos.removeWhere(
      (item) => item.id == photoId,
    );

    await _savePhotosToDisk(
      photo.chapterId,
    );
  }

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
      _photosKey(
        chapterId,
      ),
      jsonEncode(
        jsonList,
      ),
    );
  }

  Future<void> _loadPhotosFromDisk(
    String chapterId,
  ) async {

    _photos.removeWhere(
      (photo) => photo.chapterId == chapterId,
    );

    final prefs =
        await SharedPreferences.getInstance();

    final json = prefs.getString(
      _photosKey(
        chapterId,
      ),
    );

    if (json == null) {
      return;
    }

    final list =
        jsonDecode(json) as List;

    _photos.addAll(
      list.map(
        (e) => RelationshipPhoto.fromJson(
          Map<String, dynamic>.from(
            e,
          ),
        ),
      ),
    );
  }
}