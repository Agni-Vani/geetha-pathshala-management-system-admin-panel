import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'notice_target_model.freezed.dart';
part 'notice_target_model.g.dart';

@freezed
abstract class NoticeTargetModel extends NoticeTarget
    with _$NoticeTargetModel {
  const NoticeTargetModel._() : super();

  const factory NoticeTargetModel({
    required String id,
    required String noticeId,
    required NoticeTargetType targetType,
    required String? targetId,
  }) = _NoticeTargetModel;

  factory NoticeTargetModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeTargetModelFromJson(json);
}
