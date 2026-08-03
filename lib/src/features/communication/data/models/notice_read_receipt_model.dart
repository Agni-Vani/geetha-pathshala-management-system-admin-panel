import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'notice_read_receipt_model.freezed.dart';
part 'notice_read_receipt_model.g.dart';

@freezed
abstract class NoticeReadReceiptModel extends NoticeReadReceipt
    with _$NoticeReadReceiptModel {
  const NoticeReadReceiptModel._() : super();

  const factory NoticeReadReceiptModel({
    required String id,
    required String noticeId,
    required String personId,
    required String userAccountId,
    required DateTime readAt,
  }) = _NoticeReadReceiptModel;

  factory NoticeReadReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeReadReceiptModelFromJson(json);
}
