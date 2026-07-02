/// Životní cyklus kapitoly Relationship Book.
enum ChapterStatus {
  /// Autor ještě nezačal psát.
  draft,

  /// Autor dopsal svůj pohled a čeká se na partnera.
  waitingForPartner,

  /// Oba účastníci přidali svůj pohled.
  completed,

  /// Kapitola je archivována.
  archived,
}