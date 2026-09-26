final class ListGroupsParams {
  final String pathshalaId;
  final String? academicYearId;

  const ListGroupsParams({
    required this.pathshalaId,
    this.academicYearId,
  });
}

final class ListClassSchedulesParams {
  final String? pathshalaId;

  const ListClassSchedulesParams({this.pathshalaId});
}
