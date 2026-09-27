import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'user_role_model.freezed.dart';
part 'user_role_model.g.dart';

@freezed
abstract class UserRoleModel extends UserRole with _$UserRoleModel {
  const UserRoleModel._() : super();

  const factory UserRoleModel({
    required String id,
    required String userAccountId,
    required String roleId,
    required String roleCode,
    required String? scopeOrganizationId,
    required String? scopePathshalaId,
    required DateTime effectiveFrom,
    required DateTime? effectiveTo,
    required String? grantedByUserId,
    required UserRoleStatus status,
  }) = _UserRoleModel;

  factory UserRoleModel.fromJson(Map<String, dynamic> json) =>
      _$UserRoleModelFromJson(json);
}
