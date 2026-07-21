import 'package:firebase_auth/firebase_auth.dart';

import '../../services/partner_link_service.dart';

class PartnerService {
  static const String myId = 'me';
  static const String partnerId = 'partner';

  static String? currentUid;
  static String? partnerUid;

  static bool get isReady =>
      currentUid != null;

  static bool get hasPartner =>
      partnerUid != null;

  static Future<void> initialize() async {
    currentUid =
        FirebaseAuth.instance.currentUser?.uid;

    partnerUid =
        await PartnerLinkService.getPartnerUid();
  }

  static bool isMine(String authorId) {
    if (isReady) {
      return authorId == currentUid;
    }

    return authorId == myId;
  }

  static bool isPartner(String authorId) {
    if (isReady) {
      return authorId == partnerUid;
    }

    return authorId == partnerId;
  }

  static void clear() {
    currentUid = null;
    partnerUid = null;
  }
}