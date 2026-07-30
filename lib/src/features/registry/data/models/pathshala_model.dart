import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'pathshala_model.freezed.dart';
part 'pathshala_model.g.dart';

/// JSON-ready data model for a registered Pathshala.
@freezed
abstract class PathshalaModel extends Pathshala with _$PathshalaModel {
  const PathshalaModel._() : super();

  const factory PathshalaModel({
    required String id,
    required String organizationId,
    required String code,
    required String name,
    required PathshalaStatus status,
    required PathshalaAddressModel address,
    required GeoCoordinateModel? coordinate,
    required DateTime? startedOn,
    required DateTime? closedOn,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PathshalaModel;

  /// Creates a Pathshala model from API or local mock JSON.
  factory PathshalaModel.fromJson(Map<String, dynamic> json) =>
      _$PathshalaModelFromJson(json);
}

/// JSON-ready data model for a Pathshala address value object.
@freezed
abstract class PathshalaAddressModel extends PathshalaAddress
    with _$PathshalaAddressModel {
  const PathshalaAddressModel._() : super();

  const factory PathshalaAddressModel({
    required String addressLine1,
    required String? addressLine2,
    required String city,
    required String region,
    required String country,
    required String? postalCode,
  }) = _PathshalaAddressModel;

  /// Creates an address model from API or local mock JSON.
  factory PathshalaAddressModel.fromJson(Map<String, dynamic> json) =>
      _$PathshalaAddressModelFromJson(json);
}

/// JSON-ready data model for a geographic coordinate value object.
@freezed
abstract class GeoCoordinateModel extends GeoCoordinate
    with _$GeoCoordinateModel {
  const GeoCoordinateModel._() : super();

  const factory GeoCoordinateModel({
    required double latitude,
    required double longitude,
  }) = _GeoCoordinateModel;

  /// Creates a coordinate model from API or local mock JSON.
  factory GeoCoordinateModel.fromJson(Map<String, dynamic> json) =>
      _$GeoCoordinateModelFromJson(json);
}
