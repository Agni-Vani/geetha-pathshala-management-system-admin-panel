import '../../domain/entities/entities.dart';

final class NoticeTargetModel extends NoticeTarget {
  @override
  final String id;
  @override
  final String noticeId;
  @override
  final NoticeTargetType targetType;
  @override
  final String? targetId;

  const NoticeTargetModel({
    required this.id,
    required this.noticeId,
    required this.targetType,
    required this.targetId,
  });

  factory NoticeTargetModel.fromJson(Map<String, dynamic> json) {
    return NoticeTargetModel(
      id: json['id'] as String,
      noticeId: json['notice_id'] as String,
      targetType: NoticeTargetType.values.byName(json['target_type'] as String),
      targetId: json['target_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'notice_id': noticeId,
    'target_type': targetType.name,
    'target_id': targetId,
  };
}
