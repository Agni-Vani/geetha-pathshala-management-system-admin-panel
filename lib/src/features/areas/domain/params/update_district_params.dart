final class UpdateDistrictParams {
  final String districtId;
  final String? name;
  final String? division;
  final String? status;

  const UpdateDistrictParams({
    required this.districtId,
    this.name,
    this.division,
    this.status,
  });
}
