class PartnerService {
  static const String myId = 'me';
  static const String partnerId = 'partner';

  static bool isMine(String authorId) {
    return authorId == myId;
  }

  static bool isPartner(String authorId) {
    return authorId == partnerId;
  }
}