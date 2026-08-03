import '../entities/entities.dart';

/// Filter criteria for Pathshala registry listing.
final class ListPathshalasParams {
  final String organizationId;
  final PathshalaStatus? status;
  final String? searchQuery;

  const ListPathshalasParams({
    required this.organizationId,
    required this.status,
    required this.searchQuery,
  });
}
