import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'attendance_session_model.freezed.dart';
part 'attendance_session_model.g.dart';

@freezed
abstract class AttendanceSessionModel extends AttendanceSession
    with _$AttendanceSessionModel {
  const AttendanceSessionModel._() : super();

  const factory AttendanceSessionModel({
    required String id,
    required String groupId,
    required DateTime sessionDate,
    required String takenByUserId,
    required SessionStatus status,
    required DateTime createdAt,
  }) = _AttendanceSessionModel;

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSessionModelFromJson(json);
}
