abstract class PersonWorkExperience {
  const PersonWorkExperience();

  String get id;
  String get personId;
  String get organizationName;
  String get roleOrDesignation;
  String? get departmentOrUnit;
  String get engagementType;
  String? get location;
  DateTime get startDate;
  DateTime? get endDate;
  bool get isOngoing;
  String? get responsibilities;
  String? get createdByUserId;
  String get createdByRoleAtTime;
  String get createdByNameSnapshot;
  DateTime get createdAt;
  DateTime get updatedAt;
}
