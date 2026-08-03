import '../entities/entities.dart';

/// Filter criteria for committee registry listing.
final class ListCommitteesParams {
  final String organizationId;
  final String? pathshalaId;
  final CommitteeType? type;
  final CommitteeStatus? status;

  const ListCommitteesParams({
    required this.organizationId,
    required this.pathshalaId,
    required this.type,
    required this.status,
  });
}
