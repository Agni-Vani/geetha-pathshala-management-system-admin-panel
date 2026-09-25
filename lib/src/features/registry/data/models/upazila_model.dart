import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'upazila_model.freezed.dart';
part 'upazila_model.g.dart';

/// JSON-ready data model for the Upazila entity.
@freezed
abstract class UpazilaModel extends Upazila with _$UpazilaModel {
  const UpazilaModel._() : super();

  const factory UpazilaModel({
    required String id,
    @JsonKey(name: 'district_id') required String districtId,
    required String name,
    @Default('active') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UpazilaModel;

  /// Creates an upazila model from API or local mock JSON.
  factory UpazilaModel.fromJson(Map<String, dynamic> json) =>
      _$UpazilaModelFromJson(json);
}
