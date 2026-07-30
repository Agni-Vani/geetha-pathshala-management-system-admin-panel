import 'registry_enums.dart';

/// Historical relationship between two registered people.
abstract class PersonRelationship {
  const PersonRelationship();

  String get id;
  String get personId;
  String get relatedPersonId;
  PersonRelationshipType get type;
  bool get isPrimaryGuardian;
  DateTime get effectiveFrom;
  DateTime? get effectiveTo;

  /// Checks whether this relationship is active on a specific business date.
  bool isActiveOn(DateTime date) {
    final startsOnOrBeforeDate = !effectiveFrom.isAfter(date);
    final hasNotEnded = effectiveTo == null || !effectiveTo!.isBefore(date);
    return startsOnOrBeforeDate && hasNotEnded;
  }
}
