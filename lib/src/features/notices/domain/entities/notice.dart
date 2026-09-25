import 'communication_enums.dart';

abstract class Notice {
  const Notice();

  String get id;
  String get organizationId;
  String? get pathshalaId;
  String get title;
  String get content;
  NoticeStatus get status;
  DateTime? get publishedAt;
  String get createdByUserId;
  DateTime get createdAt;
}
