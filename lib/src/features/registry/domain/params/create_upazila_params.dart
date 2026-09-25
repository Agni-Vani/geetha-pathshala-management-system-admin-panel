final class CreateUpazilaParams {
  final String districtId;
  final String name;
  final String status;

  const CreateUpazilaParams({
    required this.districtId,
    required this.name,
    this.status = 'active',
  });
}
