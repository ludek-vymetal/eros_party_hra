import '../models/relationship_photo.dart';
import '../models/relationship_reflection.dart';
import 'partner_service.dart';

class PermissionService {
  const PermissionService._();

  static bool canEditReflection(
    RelationshipReflection reflection,
  ) {
    return PartnerService.isMine(
      reflection.authorId,
    );
  }

  static bool canDeletePhoto(
    RelationshipPhoto photo,
  ) {
    return PartnerService.isMine(
      photo.authorId,
    );
  }

  static bool canEditPhoto(
    RelationshipPhoto photo,
  ) {
    return PartnerService.isMine(
      photo.authorId,
    );
  }
}