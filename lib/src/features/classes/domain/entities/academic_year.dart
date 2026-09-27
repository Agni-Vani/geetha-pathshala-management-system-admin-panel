import 'classes_enums.dart';

abstract class AcademicYear {
  const AcademicYear();

  String get id;
  String get organizationId;
  String get name;
  DateTime get startDate;
  DateTime get endDate;
  AcademicYearStatus get status;
  DateTime get createdAt;
}
