import '../entities/entities.dart';

final class ListPathshalasParams {
  final String organizationId;
  final PathshalaStatus? status;
  final String? searchQuery;
  final int page;
  final int pageSize;

  const ListPathshalasParams({
    required this.organizationId,
    this.status,
    this.searchQuery,
    this.page = 1,
    this.pageSize = 20,
  });
}
