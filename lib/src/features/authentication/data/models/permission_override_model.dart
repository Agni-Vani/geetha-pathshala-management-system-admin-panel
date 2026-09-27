import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'permission_override_model.freezed.dart';
part 'permission_override_model.g.dart';

@freezed
abstract class PermissionOverrideModel extends PermissionOverride
    with _$PermissionOverrideModel {
  const PermissionOverrideModel._() : super();

  const factory PermissionOverrideModel({
    required String id,
    required String userAccountId,
    required String permissionId,
    required String permissionCode,
    required bool isGranted,
    required String? scopeOrganizationId,
    required String? scopePathshalaId,
    required DateTime effectiveFrom,
    required DateTime? effectiveTo,
    required String reason,
  }) = _PermissionOverrideModel;

  factory PermissionOverrideModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionOverrideModelFromJson(json);
}
