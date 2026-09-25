import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'attendance_datasource.dart';

final class SupabaseAttendanceDatasource implements AttendanceDatasource {
  final SupabaseClient client;

  SupabaseAttendanceDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  Future<dynamic> _invoke(String action, Map<String, dynamic> body) async {
    final response = await client.functions.invoke(
      'education-api',
      body: {'action': action, ...body},
    );
    if (response.status != 200) {
      throw StateError('Edge Function error: ${response.data}');
    }
    return response.data;
  }

  @override
  Future<AttendanceSessionModel> recordAttendance(
    RecordAttendanceParams params,
  ) async {
    final data = await _invoke('recordAttendance', {
      'groupId': params.groupId,
      'sessionDate': params.sessionDate.toIso8601String(),
      'takenByUserId': params.takenByUserId,
      'entries':
          params.entries
              .map(
                (e) => {
                  'personId': e.personId,
                  'status': e.status.name,
                  'remarks': e.remarks,
                },
              )
              .toList(),
    });
    return AttendanceSessionModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<AttendanceRecordModel>> getSessionAttendance(
    String sessionId,
  ) async {
    final data = await _invoke('getSessionAttendance', {
      'sessionId': sessionId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map(
          (json) =>
              AttendanceRecordModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
