import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'organization_model.freezed.dart';
part 'organization_model.g.dart';

/// JSON-ready data model for the governing organization registry entity.
@freezed
abstract class OrganizationModel extends Organization with _$OrganizationModel {
  const OrganizationModel._() : super();

  const factory OrganizationModel({
    required String id,
    required String officialName,
    required String displayName,
    required OrganizationStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OrganizationModel;

  /// Creates an organization model from API or local mock JSON.
  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);
}
