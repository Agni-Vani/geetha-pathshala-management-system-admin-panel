import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
abstract class NoticeModel extends Notice with _$NoticeModel {
  const NoticeModel._() : super();

  const factory NoticeModel({
    required String id,
    required String organizationId,
    required String? pathshalaId,
    required String title,
    required String content,
    required NoticeStatus status,
    required DateTime? publishedAt,
    required String createdByUserId,
    required DateTime createdAt,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
}
