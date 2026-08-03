import '../../domain/entities/entities.dart';

final class NoticeReadReceiptModel extends NoticeReadReceipt {
  @override
  final String id;
  @override
  final String noticeId;
  @override
  final String personId;
  @override
  final String userAccountId;
  @override
  final DateTime readAt;

  const NoticeReadReceiptModel({
    required this.id,
    required this.noticeId,
    required this.personId,
    required this.userAccountId,
    required this.readAt,
  });

  factory NoticeReadReceiptModel.fromJson(Map<String, dynamic> json) {
    return NoticeReadReceiptModel(
      id: json['id'] as String,
      noticeId: json['notice_id'] as String,
      personId: json['person_id'] as String,
      userAccountId: json['user_account_id'] as String,
      readAt: DateTime.parse(json['read_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'notice_id': noticeId,
    'person_id': personId,
    'user_account_id': userAccountId,
    'read_at': readAt.toIso8601String(),
  };
}
