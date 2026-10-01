abstract class PersonEducation {
  const PersonEducation();

  String get id;
  String get personId;
  String get academicLevel;
  String? get disciplineOrGroup;
  String get institutionName;
  String? get governingBoard;
  int? get startYear;
  int? get passingYear;
  bool get isOngoing;
  String? get resultOrScore;
  String? get remarks;
  String? get createdByUserId;
  String get createdByRoleAtTime;
  String get createdByNameSnapshot;
  DateTime get createdAt;
  DateTime get updatedAt;
}
