abstract class AcademicLevel {
  const AcademicLevel();

  String get id;
  String get programId;
  String get name;
  String get code;
  int get sequence;
  String? get description;
  String get status; // 'active' | 'inactive'
  DateTime get createdAt;
}
