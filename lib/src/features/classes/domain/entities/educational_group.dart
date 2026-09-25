import 'classes_enums.dart';

abstract class EducationalGroup {
  const EducationalGroup();

  String get id;
  String get pathshalaId;
  String get academicYearId;
  String get name;
  String get gradeLevel;
  GroupStatus get status;
  DateTime get createdAt;
}
