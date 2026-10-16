final class DeleteUpazilaParams {
  final String upazilaId;
  final bool softDeleteOnly;

  const DeleteUpazilaParams({
    required this.upazilaId,
    this.softDeleteOnly = false,
  });
}
