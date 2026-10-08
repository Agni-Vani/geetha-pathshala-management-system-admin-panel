import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/classes/data/datasources/mock_classes_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/classes/data/repositories/classes_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/classes/domain/entities/entities.dart';
import 'package:geetha_pathshala_management_web/src/features/classes/domain/params/params.dart';

void main() {
  group('ClassesRepositoryImpl Tests', () {
    late MockClassesDatasource mockDatasource;
    late ClassesRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockClassesDatasource(processingDelay: Duration.zero);
      repository = ClassesRepositoryImpl(datasource: mockDatasource);
    });

    test('listEducationalGroups returns matching groups', () async {
      final response = await repository.listEducationalGroups(
        const ListGroupsParams(pathshalaId: 'pathshala-dhaka-central'),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall<List<EducationalGroup>>;
      expect(success.data!.length, greaterThanOrEqualTo(1));
    });

    test('listAcademicYears returns matching academic years', () async {
      final response = await repository.listAcademicYears('org-gp-central');
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall<List<AcademicYear>>;
      expect(success.data!.length, greaterThanOrEqualTo(1));
    });

    test('listClassSchedules returns seeded schedules', () async {
      final response = await repository.listClassSchedules(
        const ListClassSchedulesParams(pathshalaId: 'pathshala-dhaka-central'),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall<List<ClassSchedule>>;
      expect(success.data!.length, greaterThanOrEqualTo(1));
      expect(success.data!.first.subject, isNotEmpty);
    });

    test('listAcademicPrograms returns seeded programs with their dynamic levels', () async {
      final response = await repository.listAcademicPrograms();
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall<List<AcademicProgram>>;
      expect(success.data!.length, greaterThanOrEqualTo(3));

      final gitaProg = success.data!.firstWhere((p) => p.code == 'GITA-BASIC');
      expect(gitaProg.levelTermLabel, 'লেভেল');
      expect(gitaProg.levels.length, 3);

      final schoolProg = success.data!.firstWhere((p) => p.code == 'GEN-SCHOOL');
      expect(schoolProg.levelTermLabel, 'শ্রেণি');
      expect(schoolProg.levels.length, 5);
    });

    test('createAcademicProgram creates dynamic program', () async {
      final response = await repository.createAcademicProgram(
        const CreateAcademicProgramParams(
          name: 'সংস্কৃত ভাষা শিক্ষা',
          code: 'SANSKRIT-DIPLOMA',
          levelTermLabel: 'পর্ব',
          description: 'সংস্কৃত ব্যাকরণ ও সাহিত্য ডিপ্লোমা',
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall<AcademicProgram>;
      expect(success.data!.name, 'সংস্কৃত ভাষা শিক্ষা');
      expect(success.data!.levelTermLabel, 'পর্ব');
    });

    test('createAcademicLevel adds new level to program', () async {
      final response = await repository.createAcademicLevel(
        const CreateAcademicLevelParams(
          programId: 'prog-gita-basic',
          name: 'লেভেল ৪ - আচার্য স্তর',
          code: 'L-04',
          sequence: 4,
          description: 'গীতা শিক্ষক প্রশিক্ষণ',
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall<AcademicLevel>;
      expect(success.data!.name, 'লেভেল ৪ - আচার্য স্তর');
      expect(success.data!.sequence, 4);
    });

    test('createEducationalGroup creates class section and assigns class teacher', () async {
      final response = await repository.createEducationalGroup(
        const CreateEducationalGroupParams(
          pathshalaId: 'pathshala-dhaka-central',
          academicYearId: 'ay-2026',
          programId: 'prog-gita-basic',
          levelId: 'prog-gita-basic-l1',
          name: 'গ শাখা (সন্ধ্যা ব্যাচ)',
          gradeLevel: 'লেভেল ১ - প্রারম্ভিক',
          classTeacherId: 'teacher-anirban',
          classTeacherName: 'অনির্বাণ সেন',
          room: 'কক্ষ ১০৩',
          maxCapacity: 25,
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall<EducationalGroup>;
      expect(success.data!.name, 'গ শাখা (সন্ধ্যা ব্যাচ)');
      expect(success.data!.classTeacherName, 'অনির্বাণ সেন');
    });
  });
}
