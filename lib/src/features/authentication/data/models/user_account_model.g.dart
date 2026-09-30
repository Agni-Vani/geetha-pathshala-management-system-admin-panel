// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserAccountModel _$UserAccountModelFromJson(Map<String, dynamic> json) =>
    _UserAccountModel(
      id: json['id'] as String,
      personId: json['personId'] as String,
      authUserId: json['authUserId'] as String?,
      email: json['email'] as String,
      status: $enumDecode(_$AccountStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserAccountModelToJson(_UserAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personId': instance.personId,
      'authUserId': instance.authUserId,
      'email': instance.email,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AccountStatusEnumMap = {
  AccountStatus.pending: 'pending',
  AccountStatus.active: 'active',
  AccountStatus.suspended: 'suspended',
  AccountStatus.deactivated: 'deactivated',
};
