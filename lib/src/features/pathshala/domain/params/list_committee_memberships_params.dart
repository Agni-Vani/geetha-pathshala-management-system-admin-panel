import '../entities/entities.dart';

/// Filter criteria for committee membership listing.
final class ListCommitteeMembershipsParams {
  final String committeeId;
  final CommitteeMembershipStatus? status;

  const ListCommitteeMembershipsParams({
    required this.committeeId,
    required this.status,
  });
}
