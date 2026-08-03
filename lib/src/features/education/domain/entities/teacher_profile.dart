import 'education_enums.dart';

abstract class TeacherProfile {
  const TeacherProfile();

  String get id;
  String get personId;
  String get organizationId;
  TeacherStatus get status;
  DateTime get joinedDate;
}
