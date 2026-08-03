import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'communication_datasource.dart';

final class SupabaseCommunicationDatasource
    implements CommunicationDatasource {
  final SupabaseClient client;

  SupabaseCommunicationDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  @override
  Future<NoticeModel> publishNotice(PublishNoticeParams params) async {
    final response = await client
        .schema('communication')
        .from('notices')
        .insert({
          'organization_id': params.organizationId,
          'pathshala_id': params.pathshalaId,
          'title': params.title,
          'content': params.content,
          'status': 'published',
          'published_at': DateTime.now().toIso8601String(),
          'created_by_user_id': params.createdByUserId,
        })
        .select()
        .single();
    return NoticeModel.fromJson(response);
  }

  @override
  Future<List<NoticeModel>> getNotices(GetNoticesParams params) async {
    var query = client
        .schema('communication')
        .from('notices')
        .select()
        .eq('organization_id', params.organizationId);

    if (params.pathshalaId != null) {
      query = query.eq('pathshala_id', params.pathshalaId!);
    }
    final response = await query;
    return (response as List)
        .map((json) => NoticeModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<NoticeReadReceiptModel> recordReadReceipt(
    RecordReadReceiptParams params,
  ) async {
    final response = await client
        .schema('communication')
        .from('notice_read_receipts')
        .insert({
          'notice_id': params.noticeId,
          'person_id': params.personId,
          'user_account_id': params.userAccountId,
          'read_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();
    return NoticeReadReceiptModel.fromJson(response);
  }

  @override
  Future<List<NoticeTargetModel>> getNoticeTargets(String noticeId) async {
    final response = await client
        .schema('communication')
        .from('notice_targets')
        .select()
        .eq('notice_id', noticeId);
    return (response as List)
        .map((json) => NoticeTargetModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
