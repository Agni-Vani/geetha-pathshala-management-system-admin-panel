import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'student_transfer_model.freezed.dart';
part 'student_transfer_model.g.dart';

@freezed
abstract class StudentTransferModel extends StudentTransfer
    with _$StudentTransferModel {
  const StudentTransferModel._() : super();

  const factory StudentTransferModel({
    required String id,
    required String personId,
    required String fromPathshalaId,
    required String toPathshalaId,
    required DateTime requestedDate,
    required TransferStatus status,
    required String? reason,
    required String? approvedByUserId,
  }) = _StudentTransferModel;

  factory StudentTransferModel.fromJson(Map<String, dynamic> json) =>
      _$StudentTransferModelFromJson(json);
}
