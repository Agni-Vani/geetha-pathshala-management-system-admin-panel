import 'communication_enums.dart';

abstract class NoticeTarget {
  const NoticeTarget();

  String get id;
  String get noticeId;
  NoticeTargetType get targetType;
  String? get targetId;
}
