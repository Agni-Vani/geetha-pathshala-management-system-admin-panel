import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'district_model.freezed.dart';
part 'district_model.g.dart';

/// JSON-ready data model for the District entity.
@freezed
abstract class DistrictModel extends District with _$DistrictModel {
  const DistrictModel._() : super();

  const factory DistrictModel({
    required String id,
    required String name,
    required String division,
    @Default('active') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DistrictModel;

  /// Creates a district model from API or local mock JSON.
  factory DistrictModel.fromJson(Map<String, dynamic> json) =>
      _$DistrictModelFromJson(json);
}
