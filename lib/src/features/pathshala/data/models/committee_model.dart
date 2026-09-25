import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'committee_model.freezed.dart';
part 'committee_model.g.dart';

/// JSON-ready data model for a governance committee.
@freezed
abstract class CommitteeModel extends Committee with _$CommitteeModel {
  const CommitteeModel._() : super();

  const factory CommitteeModel({
    required String id,
    required String organizationId,
    required String? pathshalaId,
    required String name,
    required CommitteeType type,
    required CommitteeStatus status,
  }) = _CommitteeModel;

  /// Creates a committee model from API or local mock JSON.
  factory CommitteeModel.fromJson(Map<String, dynamic> json) =>
      _$CommitteeModelFromJson(json);
}

/// JSON-ready data model for a person's committee membership.
@freezed
abstract class CommitteeMembershipModel extends CommitteeMembership
    with _$CommitteeMembershipModel {
  const CommitteeMembershipModel._() : super();

  const factory CommitteeMembershipModel({
    required String id,
    required String committeeId,
    required String personId,
    required String title,
    required DateTime effectiveFrom,
    required DateTime? effectiveTo,
    required CommitteeMembershipStatus status,
  }) = _CommitteeMembershipModel;

  /// Creates a committee membership model from API or local mock JSON.
  factory CommitteeMembershipModel.fromJson(Map<String, dynamic> json) =>
      _$CommitteeMembershipModelFromJson(json);
}
