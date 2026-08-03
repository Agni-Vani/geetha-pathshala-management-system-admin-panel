import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'communication_datasource.dart';

final class SupabaseCommunicationDatasource
    implements CommunicationDatasource {
  final SupabaseClient client;

  SupabaseCommunicationDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  Future<dynamic> _invoke(String action, Map<String, dynamic> body) async {
    final response = await client.functions.invoke(
      'communication-api',
      body: {'action': action, ...body},
    );
    if (response.status != 200) {
      throw StateError('Edge Function error: ${response.data}');
    }
    return response.data;
  }

  @override
  Future<NoticeModel> publishNotice(PublishNoticeParams params) async {
    final data = await _invoke('publishNotice', {
      'organizationId': params.organizationId,
      'pathshalaId': params.pathshalaId,
      'title': params.title,
      'content': params.content,
      'createdByUserId': params.createdByUserId,
      'targets':
          params.targets
              .map(
                (t) => {
                  'targetType': t.targetType.name,
                  'targetId': t.targetId,
                },
              )
              .toList(),
    });
    return NoticeModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<NoticeModel>> getNotices(GetNoticesParams params) async {
    final data = await _invoke('getNotices', {
      'organizationId': params.organizationId,
      'pathshalaId': params.pathshalaId,
      'page': params.page,
      'pageSize': params.pageSize,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map((json) => NoticeModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<NoticeReadReceiptModel> recordReadReceipt(
    RecordReadReceiptParams params,
  ) async {
    final data = await _invoke('recordReadReceipt', {
      'noticeId': params.noticeId,
      'personId': params.personId,
      'userAccountId': params.userAccountId,
    });
    return NoticeReadReceiptModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<NoticeTargetModel>> getNoticeTargets(String noticeId) async {
    final data = await _invoke('getNoticeTargets', {'noticeId': noticeId});
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map((json) => NoticeTargetModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
