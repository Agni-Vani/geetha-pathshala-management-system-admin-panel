class CreateDivisionParams {
  final String name;
  final String status;

  const CreateDivisionParams({
    required this.name,
    this.status = 'active',
  });
}
