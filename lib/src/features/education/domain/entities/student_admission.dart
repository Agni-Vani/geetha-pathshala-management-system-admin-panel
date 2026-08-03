import 'education_enums.dart';

abstract class StudentAdmission {
  const StudentAdmission();

  String get id;
  String get organizationId;
  String get pathshalaId;
  String get personId;
  String get rollNumber;
  DateTime get admissionDate;
  AdmissionStatus get status;
  DateTime get createdAt;
}
