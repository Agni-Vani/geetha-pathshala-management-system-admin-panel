import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

@freezed
abstract class RoleModel extends Role with _$RoleModel {
  const RoleModel._() : super();

  const factory RoleModel({
    required String id,
    required String code,
    required String name,
    required RoleScopeType scopeType,
    required String? description,
    required List<String> permissionCodes,
    required DateTime createdAt,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);
}
