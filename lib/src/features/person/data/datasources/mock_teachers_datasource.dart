import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'teachers_datasource.dart';

final class MockTeachersDatasource implements TeachersDatasource {
  final Duration processingDelay;
  final List<TeacherProfileModel> _teacherProfiles;
  final List<TeacherAssignmentModel> _teacherAssignments;
  final List<TeacherModel> _teachers;

  MockTeachersDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _teacherProfiles = [],
       _teacherAssignments = [],
       _teachers = _seedTeachers();

  @override
  Future<TeacherProfileModel> createTeacherProfile(
    CreateTeacherProfileParams params,
  ) async {
    await _simulateProcessing();
    final profile = TeacherProfileModel(
      id: 'teacher-${DateTime.now().millisecondsSinceEpoch}',
      personId: params.personId,
      organizationId: params.organizationId,
      status: TeacherStatus.active,
      joinedDate: DateTime.now(),
    );
    _teacherProfiles.add(profile);
    return profile;
  }

  @override
  Future<TeacherAssignmentModel> assignTeacher(
    AssignTeacherParams params,
  ) async {
    await _simulateProcessing();
    final assignment = TeacherAssignmentModel(
      id: 'assign-${DateTime.now().millisecondsSinceEpoch}',
      teacherProfileId: params.teacherProfileId,
      pathshalaId: params.pathshalaId,
      groupId: params.groupId,
      role: params.role,
      effectiveFrom: params.effectiveFrom,
      effectiveTo: params.effectiveTo,
    );
    _teacherAssignments.add(assignment);
    return assignment;
  }

  @override
  Future<List<TeacherAssignmentModel>> listTeacherAssignments(
    ListTeacherAssignmentsParams params,
  ) async {
    await _simulateProcessing();
    return _teacherAssignments
        .where((a) => a.pathshalaId == params.pathshalaId)
        .toList();
  }

  @override
  Future<List<TeacherModel>> listTeachers(ListTeachersParams params) async {
    await _simulateProcessing();
    return _teachers.where((t) {
      if (params.pathshalaId != null &&
          params.pathshalaId != 'All Pathshalas' &&
          t.pathshala != params.pathshalaId) {
        return false;
      }
      if (params.subject != null &&
          params.subject != 'All Subjects' &&
          t.subject != params.subject) {
        return false;
      }
      if (params.search != null && params.search!.trim().isNotEmpty) {
        final query = params.search!.trim().toLowerCase();
        final match = t.name.toLowerCase().contains(query) ||
            t.subject.toLowerCase().contains(query) ||
            t.pathshala.toLowerCase().contains(query);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }

  static List<TeacherModel> _seedTeachers() {
    return [
      const TeacherModel(
        id: 't-001',
        name: 'রমেশ শাস্ত্রী',
        subject: 'সংস্কৃত',
        pathshala: 'Dhaka Central Gita Pathshala',
        isActive: true,
        degree: 'MA in Sanskrit',
        gender: 'Male',
        phone: '+880 1711-000001',
        email: 'ramesh.shastri@geethapathshala.org',
      ),
      const TeacherModel(
        id: 't-002',
        name: 'সরস্বতী দেবী',
        subject: 'ভগবদ্গীতা',
        pathshala: 'Chattogram North Gita Pathshala',
        isActive: true,
        degree: 'Acharya in Gita Studies',
        gender: 'Female',
        phone: '+880 1711-000002',
        email: 'saraswati.devi@geethapathshala.org',
      ),
      const TeacherModel(
        id: 't-003',
        name: 'মহেশ শর্মা',
        subject: 'হিন্দি',
        pathshala: 'Sylhet East Gita Pathshala',
        isActive: true,
        degree: 'BA in Literature',
        gender: 'Male',
        phone: '+880 1711-000003',
        email: 'mahesh.sharma@geethapathshala.org',
      ),
      const TeacherModel(
        id: 't-004',
        name: 'অঞ্জলি ভার্মা',
        subject: 'গণিত',
        pathshala: 'Dhaka Central Gita Pathshala',
        isActive: true,
        degree: 'BSc in Mathematics',
        gender: 'Female',
        phone: '+880 1711-000004',
        email: 'anjali.verma@geethapathshala.org',
      ),
      const TeacherModel(
        id: 't-005',
        name: 'বিক্রম যোশী',
        subject: 'সান্ধ্যকালীন ক্লাস',
        pathshala: 'Chattogram North Gita Pathshala',
        isActive: false,
        degree: 'Diploma in Education',
        gender: 'Male',
        phone: '+880 1711-000005',
        email: 'bikram.joshi@geethapathshala.org',
      ),
      const TeacherModel(
        id: 't-006',
        name: 'অনির্বাণ সেন',
        subject: 'শ্রীমদ্ভগবদ্গীতা',
        pathshala: 'Dhaka Central Gita Pathshala',
        isActive: true,
        degree: 'PhD in Indology',
        gender: 'Male',
        phone: '+880 1711-000006',
        email: 'anirban.sen@geethapathshala.org',
      ),
      const TeacherModel(
        id: 't-007',
        name: 'ইশিতা পাল',
        subject: 'সংস্কৃত',
        pathshala: 'Dhaka Central Gita Pathshala',
        isActive: true,
        degree: 'MPhil in Sanskrit',
        gender: 'Female',
        phone: '+880 1711-000007',
        email: 'ishita.paul@geethapathshala.org',
      ),
    ];
  }
}
