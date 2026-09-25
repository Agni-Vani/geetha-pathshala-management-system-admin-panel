final class AdmitStudentParams {
  final String organizationId;
  final String pathshalaId;
  final String personId;
  final String rollNumber;

  const AdmitStudentParams({
    required this.organizationId,
    required this.pathshalaId,
    required this.personId,
    required this.rollNumber,
  });
}

final class TransferStudentParams {
  final String personId;
  final String fromPathshalaId;
  final String toPathshalaId;
  final String reason;

  const TransferStudentParams({
    required this.personId,
    required this.fromPathshalaId,
    required this.toPathshalaId,
    required this.reason,
  });
}

final class ListStudentAdmissionsParams {
  final String pathshalaId;

  const ListStudentAdmissionsParams({required this.pathshalaId});
}
