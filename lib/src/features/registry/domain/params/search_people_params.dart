/// Search criteria for finding possible person matches.
final class SearchPeopleParams {
  final String organizationId;
  final String query;
  final DateTime? dateOfBirth;
  final String? phone;
  final String? email;
  final int limit;

  const SearchPeopleParams({
    required this.organizationId,
    required this.query,
    required this.dateOfBirth,
    required this.phone,
    required this.email,
    this.limit = 20,
  });
}
