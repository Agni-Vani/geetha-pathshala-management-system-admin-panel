import '../../domain/entities/entities.dart';

final class NoticeModel extends Notice {
  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String? pathshalaId;
  @override
  final String title;
  @override
  final String content;
  @override
  final NoticeStatus status;
  @override
  final DateTime? publishedAt;
  @override
  final String createdByUserId;
  @override
  final DateTime createdAt;

  const NoticeModel({
    required this.id,
    required this.organizationId,
    required this.pathshalaId,
    required this.title,
    required this.content,
    required this.status,
    required this.publishedAt,
    required this.createdByUserId,
    required this.createdAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      pathshalaId: json['pathshala_id'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      status: NoticeStatus.values.byName(json['status'] as String),
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      createdByUserId: json['created_by_user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'organization_id': organizationId,
    'pathshala_id': pathshalaId,
    'title': title,
    'content': content,
    'status': status.name,
    'published_at': publishedAt?.toIso8601String(),
    'created_by_user_id': createdByUserId,
    'created_at': createdAt.toIso8601String(),
  };
}
