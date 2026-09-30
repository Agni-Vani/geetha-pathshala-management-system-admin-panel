import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'teacher_profile_model.freezed.dart';
part 'teacher_profile_model.g.dart';

@freezed
abstract class TeacherProfileModel extends TeacherProfile
    with _$TeacherProfileModel {
  const TeacherProfileModel._() : super();

  const factory TeacherProfileModel({
    required String id,
    required String personId,
    required String organizationId,
    required TeacherStatus status,
    required DateTime joinedDate,
  }) = _TeacherProfileModel;

  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherProfileModelFromJson(json);
}
