final class SearchPeopleParams {
  final String organizationId;
  final String? query;
  final DateTime? dateOfBirth;
  final String? phone;
  final String? email;
  final int page;
  final int pageSize;

  const SearchPeopleParams({
    required this.organizationId,
    this.query,
    this.dateOfBirth,
    this.phone,
    this.email,
    this.page = 1,
    this.pageSize = 20,
  });
}
