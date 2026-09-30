import 'classes_enums.dart';

abstract class GroupEnrollment {
  const GroupEnrollment();

  String get id;
  String get groupId;
  String get studentAdmissionId;
  String get personId;
  AdmissionStatus get status;
  DateTime get enrolledAt;
}
