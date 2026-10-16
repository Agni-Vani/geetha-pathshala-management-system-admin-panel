final class DeleteDistrictParams {
  final String districtId;
  final bool softDeleteOnly;

  const DeleteDistrictParams({
    required this.districtId,
    this.softDeleteOnly = false,
  });
}
