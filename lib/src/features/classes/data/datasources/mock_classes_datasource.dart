import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'classes_datasource.dart';

final class MockClassesDatasource implements ClassesDatasource {
  final Duration processingDelay;
  final List<AcademicYearModel> _academicYears;
  final List<AcademicProgramModel> _programs;
  final List<AcademicLevelModel> _levels;
  final List<EducationalGroupModel> _groups;
  final List<ClassScheduleModel> _schedules;

  MockClassesDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _academicYears = _seedAcademicYears(),
       _levels = _seedLevels(),
       _programs = _seedPrograms(),
       _groups = _seedGroups(),
       _schedules = _seedSchedules();

  @override
  Future<List<EducationalGroupModel>> listEducationalGroups(
    ListGroupsParams params,
  ) async {
    await _simulateProcessing();
    return _groups.where((g) {
      if (g.pathshalaId != params.pathshalaId) return false;
      if (params.academicYearId != null &&
          g.academicYearId != params.academicYearId) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<List<AcademicYearModel>> listAcademicYears(
    String organizationId,
  ) async {
    await _simulateProcessing();
    return _academicYears
        .where((ay) => ay.organizationId == organizationId)
        .toList();
  }

  @override
  Future<List<ClassScheduleModel>> listClassSchedules(
    ListClassSchedulesParams params,
  ) async {
    await _simulateProcessing();
    return _schedules.where((s) {
      if (params.pathshalaId != null &&
          params.pathshalaId != 'All Pathshalas' &&
          s.pathshalaId != null &&
          s.pathshalaId != params.pathshalaId) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<List<AcademicProgramModel>> listAcademicPrograms() async {
    await _simulateProcessing();
    return _programs.map((p) {
      final progLevels = _levels.where((l) => l.programId == p.id).toList()
        ..sort((a, b) => a.sequence.compareTo(b.sequence));
      return p.copyWith(levels: progLevels);
    }).toList();
  }

  @override
  Future<AcademicProgramModel> createAcademicProgram(
    CreateAcademicProgramParams params,
  ) async {
    await _simulateProcessing();
    final newProgram = AcademicProgramModel(
      id: 'prog-${DateTime.now().millisecondsSinceEpoch}',
      name: params.name,
      code: params.code,
      levelTermLabel: params.levelTermLabel,
      description: params.description,
      status: 'active',
      levels: const [],
      createdAt: DateTime.now(),
    );
    _programs.insert(0, newProgram);
    return newProgram;
  }

  @override
  Future<List<AcademicLevelModel>> listAcademicLevels(String programId) async {
    await _simulateProcessing();
    final result = _levels.where((l) => l.programId == programId).toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
    return result;
  }

  @override
  Future<AcademicLevelModel> createAcademicLevel(
    CreateAcademicLevelParams params,
  ) async {
    await _simulateProcessing();
    final newLevel = AcademicLevelModel(
      id: 'lvl-${DateTime.now().millisecondsSinceEpoch}',
      programId: params.programId,
      name: params.name,
      code: params.code,
      sequence: params.sequence,
      description: params.description,
      status: 'active',
      createdAt: DateTime.now(),
    );
    _levels.add(newLevel);
    return newLevel;
  }

  @override
  Future<EducationalGroupModel> createEducationalGroup(
    CreateEducationalGroupParams params,
  ) async {
    await _simulateProcessing();
    final newGroup = EducationalGroupModel(
      id: 'group-${DateTime.now().millisecondsSinceEpoch}',
      pathshalaId: params.pathshalaId,
      academicYearId: params.academicYearId,
      programId: params.programId,
      levelId: params.levelId,
      name: params.name,
      gradeLevel: params.gradeLevel,
      classTeacherId: params.classTeacherId,
      classTeacherName: params.classTeacherName,
      room: params.room,
      maxCapacity: params.maxCapacity,
      status: GroupStatus.active,
      createdAt: DateTime.now(),
    );
    _groups.add(newGroup);
    return newGroup;
  }

  @override
  Future<EducationalGroupModel> assignClassTeacher(
    AssignClassTeacherParams params,
  ) async {
    await _simulateProcessing();
    final index = _groups.indexWhere((g) => g.id == params.groupId);
    if (index == -1) {
      throw StateError('Class group not found');
    }
    final existing = _groups[index];
    final updated = existing.copyWith(
      classTeacherId: params.teacherId,
      classTeacherName: params.teacherName,
    );
    _groups[index] = updated;
    return updated;
  }

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }

  static List<AcademicYearModel> _seedAcademicYears() {
    return [
      AcademicYearModel(
        id: 'ay-2026',
        organizationId: 'org-gp-central',
        name: 'Academic Year 2026',
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
        status: AcademicYearStatus.active,
        createdAt: DateTime(2026, 1, 1),
      ),
    ];
  }

  static List<AcademicProgramModel> _seedPrograms() {
    return [
      AcademicProgramModel(
        id: 'prog-gita-basic',
        name: 'গীতা পাঠশালা মৌলিক শিক্ষা',
        code: 'GITA-BASIC',
        levelTermLabel: 'লেভেল',
        description: 'শিশু ও কিশোরদের জন্য শ্রীমদ্ভগবদ্গীতার শ্লোক ও জীবন দর্শন শিক্ষা।',
        status: 'active',
        createdAt: DateTime(2026, 1, 1),
      ),
      AcademicProgramModel(
        id: 'prog-general-school',
        name: 'সাধারণ বিদ্যালয় পাঠ্যক্রম',
        code: 'GEN-SCHOOL',
        levelTermLabel: 'শ্রেণি',
        description: 'নিয়মিত প্রাতিষ্ঠানিক স্কুলের শ্রেণিভিত্তিক শিক্ষা সহায়তা ও নৈতিক পাঠ।',
        status: 'active',
        createdAt: DateTime(2026, 1, 5),
      ),
      AcademicProgramModel(
        id: 'prog-vedanta-sem',
        name: 'বেদান্ত ও উপনিষদ উচ্চতর অধ্যয়ন',
        code: 'VEDANTA-ADV',
        levelTermLabel: 'সেমিস্টার',
        description: 'যুব ও বয়স্ক শিক্ষার্থীদের জন্য দর্শন ও উপনিষদ ভিত্তিক সেমিস্টার পদ্ধতি।',
        status: 'active',
        createdAt: DateTime(2026, 1, 10),
      ),
    ];
  }

  static List<AcademicLevelModel> _seedLevels() {
    return [
      // Program 1: Gita Basic
      AcademicLevelModel(
        id: 'prog-gita-basic-l1',
        programId: 'prog-gita-basic',
        name: 'লেভেল ১ - প্রারম্ভিক',
        code: 'L-01',
        sequence: 1,
        description: 'শ্লোক আবৃত্তি, শুদ্ধ উচ্চারণ ও মৌলিক ধারণা।',
        status: 'active',
        createdAt: DateTime(2026, 1, 1),
      ),
      AcademicLevelModel(
        id: 'prog-gita-basic-l2',
        programId: 'prog-gita-basic',
        name: 'লেভেল ২ - মধ্যম',
        code: 'L-02',
        sequence: 2,
        description: 'অধ্যায় পাঠ, সরলার্থ ও নীতি শিক্ষা।',
        status: 'active',
        createdAt: DateTime(2026, 1, 1),
      ),
      AcademicLevelModel(
        id: 'prog-gita-basic-l3',
        programId: 'prog-gita-basic',
        name: 'লেভেল ৩ - উচ্চ',
        code: 'L-03',
        sequence: 3,
        description: 'গভীর তত্ত্ব আলোচনা ও প্রায়োগিক গীতা।',
        status: 'active',
        createdAt: DateTime(2026, 1, 1),
      ),

      // Program 2: General School
      AcademicLevelModel(
        id: 'prog-gen-class-1',
        programId: 'prog-general-school',
        name: '১ম শ্রেণি',
        code: 'CLS-1',
        sequence: 1,
        description: 'প্রাথমিক স্তরের ১ম শ্রেণি।',
        status: 'active',
        createdAt: DateTime(2026, 1, 5),
      ),
      AcademicLevelModel(
        id: 'prog-gen-class-2',
        programId: 'prog-general-school',
        name: '২য় শ্রেণি',
        code: 'CLS-2',
        sequence: 2,
        description: 'প্রাথমিক স্তরের ২য় শ্রেণি।',
        status: 'active',
        createdAt: DateTime(2026, 1, 5),
      ),
      AcademicLevelModel(
        id: 'prog-gen-class-3',
        programId: 'prog-general-school',
        name: '৩য় শ্রেণি',
        code: 'CLS-3',
        sequence: 3,
        description: 'প্রাথমিক স্তরের ৩য় শ্রেণি।',
        status: 'active',
        createdAt: DateTime(2026, 1, 5),
      ),
      AcademicLevelModel(
        id: 'prog-gen-class-4',
        programId: 'prog-general-school',
        name: '৪র্থ শ্রেণি',
        code: 'CLS-4',
        sequence: 4,
        description: 'প্রাথমিক স্তরের ৪র্থ শ্রেণি।',
        status: 'active',
        createdAt: DateTime(2026, 1, 5),
      ),
      AcademicLevelModel(
        id: 'prog-gen-class-5',
        programId: 'prog-general-school',
        name: '৫ম শ্রেণি',
        code: 'CLS-5',
        sequence: 5,
        description: 'প্রাথমিক স্তরের ৫ম শ্রেণি।',
        status: 'active',
        createdAt: DateTime(2026, 1, 5),
      ),

      // Program 3: Vedanta Semesters
      AcademicLevelModel(
        id: 'prog-ved-sem-1',
        programId: 'prog-vedanta-sem',
        name: '১ম সেমিস্টার - উপনিষদ প্রবেশ',
        code: 'SEM-1',
        sequence: 1,
        description: 'ঈশ ও কেন উপনিষদ পাঠ।',
        status: 'active',
        createdAt: DateTime(2026, 1, 10),
      ),
      AcademicLevelModel(
        id: 'prog-ved-sem-2',
        programId: 'prog-vedanta-sem',
        name: '২য় সেমিস্টার - কঠ ও মুণ্ডক বিচার',
        code: 'SEM-2',
        sequence: 2,
        description: 'কঠ উপনিষদ ও মুণ্ডক উপনিষদ পর্যালোচনা।',
        status: 'active',
        createdAt: DateTime(2026, 1, 10),
      ),
    ];
  }

  static List<EducationalGroupModel> _seedGroups() {
    return [
      EducationalGroupModel(
        id: 'group-gita-basic-01',
        pathshalaId: 'pathshala-dhaka-central',
        academicYearId: 'ay-2026',
        programId: 'prog-gita-basic',
        levelId: 'prog-gita-basic-l1',
        name: 'ক শাখা (মর্নিং ব্যাচ)',
        gradeLevel: 'লেভেল ১ - প্রারম্ভিক',
        classTeacherId: 'teacher-anirban',
        classTeacherName: 'অনির্বাণ সেন',
        room: 'কক্ষ ১০১',
        maxCapacity: 30,
        status: GroupStatus.active,
        createdAt: DateTime(2026, 1, 15),
      ),
      EducationalGroupModel(
        id: 'group-gita-basic-02',
        pathshalaId: 'pathshala-dhaka-central',
        academicYearId: 'ay-2026',
        programId: 'prog-gita-basic',
        levelId: 'prog-gita-basic-l2',
        name: 'খ শাখা (বিকাল ব্যাচ)',
        gradeLevel: 'লেভেল ২ - মধ্যম',
        classTeacherId: 'teacher-madhuri',
        classTeacherName: 'মধুরী দাস',
        room: 'কক্ষ ১০২',
        maxCapacity: 25,
        status: GroupStatus.active,
        createdAt: DateTime(2026, 2, 1),
      ),
    ];
  }

  static List<ClassScheduleModel> _seedSchedules() {
    return const [
      ClassScheduleModel(
        id: 'cs-001',
        subject: 'শ্রীমদ্ভগবদ্গীতা',
        day: 'শনিবার',
        time: 'সকাল ১০:০০ - ১১:৩০',
        teacher: 'অনির্বাণ সেন',
      ),
      ClassScheduleModel(
        id: 'cs-002',
        subject: 'সংস্কৃত',
        day: 'শনিবার',
        time: 'সকাল ১১:৩০ - ১২:৩০',
        teacher: 'ইশিতা পাল',
      ),
      ClassScheduleModel(
        id: 'cs-003',
        subject: 'ভজন ও কীর্তন',
        day: 'রবিবার',
        time: 'বিকাল ৪:০০ - ৫:০০',
        teacher: 'অনির্বাণ সেন',
      ),
    ];
  }
}
