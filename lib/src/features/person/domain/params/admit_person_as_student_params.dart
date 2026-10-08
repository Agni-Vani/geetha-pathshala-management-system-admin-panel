import '../entities/student_enums.dart';

/// Parameters required to admit an existing registered person as a student of a Pathshala.
final class AdmitPersonAsStudentParams {
  final String personId;
  final String organizationId;
  final String pathshalaId;
  final String rollNumber;
  final DateTime admissionDate;
  final AdmissionStatus status;

  const AdmitPersonAsStudentParams({
    required this.personId,
    required this.organizationId,
    required this.pathshalaId,
    required this.rollNumber,
    required this.admissionDate,
    this.status = AdmissionStatus.active,
  });
}
