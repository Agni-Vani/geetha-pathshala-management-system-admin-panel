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

  @override
  Future<List<StudentModel>> listStudents(ListStudentsParams params) async {
    try {
      final data = await _invoke('listStudents', {
        'pathshalaId': params.pathshalaId,
        'studentClass': params.studentClass,
        'search': params.search,
      });
      final list =
          (data is Map && data['data'] is List)
              ? data['data'] as List
              : data as List;
      return list
          .map((json) => StudentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback: Query live Supabase database tables directly if Edge Function fails on cross-schema join
      return _listStudentsDirect(params);
    }
  }

  Future<List<StudentModel>> _listStudentsDirect(ListStudentsParams params) async {
    try {
      var query = client
          .schema('education')
          .from('student_admissions')
          .select();

      if (params.pathshalaId != null && params.pathshalaId!.isNotEmpty) {
        query = query.eq('pathshala_id', params.pathshalaId!);
      }

      final List<dynamic> admissions = await query;
      if (admissions.isEmpty) return [];

      final personIds = admissions
          .map((a) => a['person_id']?.toString())
          .whereType<String>()
          .toList();

      final List<dynamic> people = await client
          .schema('registry')
          .from('people')
          .select()
          .inFilter('id', personIds);

      final peopleMap = {
        for (final p in people) (p['id']?.toString() ?? ''): p,
      };

      return admissions.map((a) {
        final admissionId = a['id']?.toString() ?? '';
        final personId = a['person_id']?.toString() ?? '';
        final person = peopleMap[personId];
        final name = (person?['preferred_name'] ?? person?['legal_name'] ?? 'Unknown').toString();
        final roll = (a['roll_number'] ?? '—').toString();
        final status = (a['status'] ?? 'active').toString().toLowerCase();

        return StudentModel(
          id: admissionId,
          name: name,
          studentClass: params.studentClass ?? 'General',
          pathshala: params.pathshalaId ?? 'Assigned Pathshala',
          roll: roll,
          isActive: status == 'active' || status == 'admitted',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
