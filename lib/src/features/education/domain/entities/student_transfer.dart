import 'education_enums.dart';

abstract class StudentTransfer {
  const StudentTransfer();

  String get id;
  String get personId;
  String get fromPathshalaId;
  String get toPathshalaId;
  DateTime get requestedDate;
  TransferStatus get status;
  String? get reason;
  String? get approvedByUserId;
}
