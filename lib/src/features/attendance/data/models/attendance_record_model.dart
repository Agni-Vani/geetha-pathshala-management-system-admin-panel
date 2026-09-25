import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'attendance_record_model.freezed.dart';
part 'attendance_record_model.g.dart';

@freezed
abstract class AttendanceRecordModel extends AttendanceRecord
    with _$AttendanceRecordModel {
  const AttendanceRecordModel._() : super();

  const factory AttendanceRecordModel({
    required String id,
    required String sessionId,
    required String personId,
    required AttendanceStatus status,
    required String? remarks,
  }) = _AttendanceRecordModel;

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);
}
