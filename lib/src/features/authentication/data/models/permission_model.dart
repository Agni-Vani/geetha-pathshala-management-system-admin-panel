import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'permission_model.freezed.dart';
part 'permission_model.g.dart';

@freezed
abstract class PermissionModel extends Permission with _$PermissionModel {
  const PermissionModel._() : super();

  const factory PermissionModel({
    required String id,
    required String code,
    required String name,
    required String module,
    required String? description,
    required DateTime createdAt,
  }) = _PermissionModel;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionModelFromJson(json);
}
