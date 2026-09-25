// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pathshala_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PathshalaModel _$PathshalaModelFromJson(Map<String, dynamic> json) =>
    _PathshalaModel(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      status: $enumDecode(_$PathshalaStatusEnumMap, json['status']),
      districtId: json['districtId'] as String?,
      upazilaId: json['upazilaId'] as String?,
      address: PathshalaAddressModel.fromJson(
        json['address'] as Map<String, dynamic>,
      ),
      coordinate: json['coordinate'] == null
          ? null
          : GeoCoordinateModel.fromJson(
              json['coordinate'] as Map<String, dynamic>,
            ),
      startedOn: json['startedOn'] == null
          ? null
          : DateTime.parse(json['startedOn'] as String),
      closedOn: json['closedOn'] == null
          ? null
          : DateTime.parse(json['closedOn'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PathshalaModelToJson(_PathshalaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'code': instance.code,
      'name': instance.name,
      'status': _$PathshalaStatusEnumMap[instance.status]!,
      'districtId': instance.districtId,
      'upazilaId': instance.upazilaId,
      'address': instance.address,
      'coordinate': instance.coordinate,
      'startedOn': instance.startedOn?.toIso8601String(),
      'closedOn': instance.closedOn?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PathshalaStatusEnumMap = {
  PathshalaStatus.draft: 'draft',
  PathshalaStatus.active: 'active',
  PathshalaStatus.paused: 'paused',
  PathshalaStatus.closed: 'closed',
  PathshalaStatus.archived: 'archived',
};

_PathshalaAddressModel _$PathshalaAddressModelFromJson(
  Map<String, dynamic> json,
) => _PathshalaAddressModel(
  addressLine1: json['addressLine1'] as String,
  addressLine2: json['addressLine2'] as String?,
  detailedAddress: json['detailedAddress'] as String?,
  city: json['city'] as String,
  region: json['region'] as String,
  country: json['country'] as String,
  postalCode: json['postalCode'] as String?,
);

Map<String, dynamic> _$PathshalaAddressModelToJson(
  _PathshalaAddressModel instance,
) => <String, dynamic>{
  'addressLine1': instance.addressLine1,
  'addressLine2': instance.addressLine2,
  'detailedAddress': instance.detailedAddress,
  'city': instance.city,
  'region': instance.region,
  'country': instance.country,
  'postalCode': instance.postalCode,
};

_GeoCoordinateModel _$GeoCoordinateModelFromJson(Map<String, dynamic> json) =>
    _GeoCoordinateModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GeoCoordinateModelToJson(_GeoCoordinateModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
