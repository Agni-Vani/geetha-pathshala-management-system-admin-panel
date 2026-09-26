import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'events_datasource.dart';

final class SupabaseEventsDatasource implements EventsDatasource {
  final SupabaseClient client;

  SupabaseEventsDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  Future<dynamic> _invoke(String action, Map<String, dynamic> body) async {
    final response = await client.functions.invoke(
      'events-api',
      body: {'action': action, ...body},
    );
    if (response.status != 200) {
      throw StateError('Edge Function error: ${response.data}');
    }
    return response.data;
  }

  @override
  Future<List<EventModel>> listEvents(ListEventsParams params) async {
    final data = await _invoke('listEvents', {
      'pathshalaId': params.pathshalaId,
      'scope': params.scope,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map((json) => EventModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
