import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'person_model.freezed.dart';
part 'person_model.g.dart';

/// JSON-ready data model for the root person registry entity.
@freezed
abstract class PersonModel extends Person with _$PersonModel {
  const PersonModel._() : super();

  const factory PersonModel({
    required String id,
    required String organizationId,
    required String legalName,
    required String? preferredName,
    required DateTime? dateOfBirth,
    required String? gender,
    required String? primaryPhone,
    required String? primaryEmail,
    required PersonStatus status,
    required String? createdByUserId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PersonModel;

  /// Creates a person model from API or local mock JSON.
  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);
}

/// JSON-ready data model for a person's contact method.
@freezed
abstract class PersonContactModel extends PersonContact
    with _$PersonContactModel {
  const PersonContactModel._() : super();

  const factory PersonContactModel({
    required String id,
    required String personId,
    required ContactType type,
    required String label,
    required String value,
    required bool isPrimary,
    required DateTime? verifiedAt,
  }) = _PersonContactModel;

  /// Creates a contact model from API or local mock JSON.
  factory PersonContactModel.fromJson(Map<String, dynamic> json) =>
      _$PersonContactModelFromJson(json);
}

/// JSON-ready data model for a relationship between registered people.
@freezed
abstract class PersonRelationshipModel extends PersonRelationship
    with _$PersonRelationshipModel {
  const PersonRelationshipModel._() : super();

  const factory PersonRelationshipModel({
    required String id,
    required String personId,
    required String relatedPersonId,
    required PersonRelationshipType type,
    required bool isPrimaryGuardian,
    required DateTime effectiveFrom,
    required DateTime? effectiveTo,
  }) = _PersonRelationshipModel;

  /// Creates a relationship model from API or local mock JSON.
  factory PersonRelationshipModel.fromJson(Map<String, dynamic> json) =>
      _$PersonRelationshipModelFromJson(json);
}
