import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'students_datasource.dart';

final class SupabaseStudentsDatasource implements StudentsDatasource {
  final SupabaseClient client;

  SupabaseStudentsDatasource({SupabaseClient? client})
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
  Future<StudentAdmissionModel> admitStudent(AdmitStudentParams params) async {
    final data = await _invoke('admitStudent', {
      'organizationId': params.organizationId,
      'pathshalaId': params.pathshalaId,
      'personId': params.personId,
      'rollNumber': params.rollNumber,
    });
    return StudentAdmissionModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<StudentTransferModel> transferStudent(
    TransferStudentParams params,
  ) async {
    final data = await _invoke('transferStudent', {
      'personId': params.personId,
      'fromPathshalaId': params.fromPathshalaId,
      'toPathshalaId': params.toPathshalaId,
      'reason': params.reason,
    });
    return StudentTransferModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<StudentAdmissionModel>> listStudentAdmissions(
    ListStudentAdmissionsParams params,
  ) async {
    final data = await _invoke('listStudentAdmissions', {
      'pathshalaId': params.pathshalaId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map(
          (json) =>
              StudentAdmissionModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
