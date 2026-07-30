import 'registry_enums.dart';

abstract class CommitteeMembership {
  const CommitteeMembership();

  String get id;
  String get committeeId;
  String get personId;
  String get title;
  DateTime get effectiveFrom;
  DateTime? get effectiveTo;
  CommitteeMembershipStatus get status;

  bool isActiveOn(DateTime date) {
    final startsOnOrBeforeDate = !effectiveFrom.isAfter(date);
    final hasNotEnded = effectiveTo == null || !effectiveTo!.isBefore(date);
    return status == CommitteeMembershipStatus.active &&
        startsOnOrBeforeDate &&
        hasNotEnded;
  }
}
