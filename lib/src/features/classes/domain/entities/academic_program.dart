import 'academic_level.dart';

abstract class AcademicProgram {
  const AcademicProgram();

  String get id;
  String get name;
  String get code;
  /// Dynamic label used for dividing this program (e.g., 'শ্রেণি' / Class, 'লেভেল' / Level, 'সেমিস্টার' / Semester, 'পর্ব' / Part)
  String get levelTermLabel;
  String? get description;
  String get status; // 'active' | 'inactive'
  List<AcademicLevel> get levels;
  DateTime get createdAt;
}
