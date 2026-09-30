import 'pathshala_enums.dart';

/// Person's historical participation in a governance committee.
abstract class CommitteeMembership {
  const CommitteeMembership();

  String get id;
  String get committeeId;
  String get personId;
  String get title;
  DateTime get effectiveFrom;
  DateTime? get effectiveTo;
  CommitteeMembershipStatus get status;

  /// Checks whether this membership is active on a specific business date.
  bool isActiveOn(DateTime date) {
    final startsOnOrBeforeDate = !effectiveFrom.isAfter(date);
    final hasNotEnded = effectiveTo == null || !effectiveTo!.isBefore(date);
    return status == CommitteeMembershipStatus.active &&
        startsOnOrBeforeDate &&
        hasNotEnded;
  }
}
