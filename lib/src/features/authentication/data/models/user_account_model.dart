import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'user_account_model.freezed.dart';
part 'user_account_model.g.dart';

@freezed
abstract class UserAccountModel extends UserAccount with _$UserAccountModel {
  const UserAccountModel._() : super();

  const factory UserAccountModel({
    required String id,
    required String personId,
    required String? authUserId,
    required String email,
    required AccountStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserAccountModel;

  factory UserAccountModel.fromJson(Map<String, dynamic> json) =>
      _$UserAccountModelFromJson(json);
}
