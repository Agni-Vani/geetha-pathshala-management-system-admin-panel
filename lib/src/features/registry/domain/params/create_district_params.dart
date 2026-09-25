final class CreateDistrictParams {
  final String name;
  final String division;
  final String status;

  const CreateDistrictParams({
    required this.name,
    required this.division,
    this.status = 'active',
  });
}
