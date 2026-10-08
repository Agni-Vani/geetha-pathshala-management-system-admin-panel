import 'package:flutter/material.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../../classes/domain/classes_domain.dart';
import '../../../notices/domain/notices_domain.dart';
import '../../../person/domain/person_domain.dart';
import '../../domain/pathshala_domain.dart';

/// A resolved committee member: the raw [membership] paired with the
/// [person] it points to, so views don't need a second lookup.
final class PathshalaAdministrator {
  final Person person;
  final CommitteeMembership membership;

  const PathshalaAdministrator({required this.person, required this.membership});
}

class PathshalaDetailsController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  final ListCommittees listCommittees;
  final ListCommitteeMemberships listCommitteeMemberships;
  final GetPersonById getPersonById;
  final GetNotices getNotices;
  final ListStudentAdmissions listStudentAdmissions;
  final ListTeacherAssignments listTeacherAssignments;
  final ListTeachers listTeachers;
  final ListEducationalGroups listEducationalGroups;
  final ListAcademicPrograms listAcademicPrograms;
  final CreateEducationalGroup createEducationalGroup;

  PathshalaDetailsController({
    required this.listCommittees,
    required this.listCommitteeMemberships,
    required this.getPersonById,
    required this.getNotices,
    required this.listStudentAdmissions,
    required this.listTeacherAssignments,
    required this.listTeachers,
    required this.listEducationalGroups,
    required this.listAcademicPrograms,
    required this.createEducationalGroup,
  });

  List<PathshalaAdministrator> administrators = [];
  List<Teacher> pathshalaTeachers = [];
  List<EducationalGroup> classes = [];
  List<AcademicProgram> programs = [];
  int studentsCount = 0;
  int teachersCount = 0;
  int noticesCount = 0;

  /// The most senior active committee member for this Pathshala, if any —
  /// used both for the "Head" line on the overview card and as the sole
  /// entry shown on the Administrator tab.
  PathshalaAdministrator? get primaryAdministrator =>
      administrators.isEmpty ? null : administrators.first;

  Future<void> load({
    required String organizationId,
    required String pathshalaId,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final committees = await handleFutureRequest(
      request: () => listCommittees.call(
        ListCommitteesParams(
          organizationId: organizationId,
          pathshalaId: pathshalaId,
          type: null,
          status: CommitteeStatus.active,
        ),
      ),
    );

    List<CommitteeMembership> memberships = const [];
    if (committees != null && committees.isNotEmpty) {
      memberships = await handleFutureRequest(
            request: () => listCommitteeMemberships.call(
              ListCommitteeMembershipsParams(
                committeeId: committees.first.id,
                status: CommitteeMembershipStatus.active,
              ),
            ),
          ) ??
          const [];
    }

    final resolvedAdministrators = <PathshalaAdministrator>[];
    for (final membership in memberships) {
      final person = await handleFutureRequest(
        request: () => getPersonById.call(membership.personId),
      );
      if (person != null) {
        resolvedAdministrators.add(
          PathshalaAdministrator(person: person, membership: membership),
        );
      }
    }

    final notices = await handleFutureRequest(
          request: () => getNotices.call(
            GetNoticesParams(organizationId: organizationId, pathshalaId: pathshalaId),
          ),
        ) ??
        const [];

    final admissions = await handleFutureRequest(
          request: () => listStudentAdmissions.call(
            ListStudentAdmissionsParams(pathshalaId: pathshalaId),
          ),
        ) ??
        const [];

    final assignments = await handleFutureRequest(
          request: () => listTeacherAssignments.call(
            ListTeacherAssignmentsParams(pathshalaId: pathshalaId),
          ),
        ) ??
        const [];

    // Load allocated teachers for this pathshala
    final loadedTeachers = await handleFutureRequest(
          request: () => listTeachers.call(
            ListTeachersParams(pathshalaId: pathshalaId),
          ),
        ) ??
        const [];

    // Load classes / sections running at this pathshala
    final loadedClasses = await handleFutureRequest(
          request: () => listEducationalGroups.call(
            ListGroupsParams(pathshalaId: pathshalaId),
          ),
        ) ??
        const [];

    // Load academic programs
    final loadedPrograms = await handleFutureRequest(
          request: () => listAcademicPrograms.call(),
        ) ??
        const [];

    final now = DateTime.now();

    administrators = resolvedAdministrators;
    pathshalaTeachers = loadedTeachers;
    classes = loadedClasses;
    programs = loadedPrograms;
    noticesCount = notices.length;
    studentsCount = admissions.where((a) => a.status == AdmissionStatus.active).length;
    teachersCount = loadedTeachers.isNotEmpty
        ? loadedTeachers.length
        : assignments
            .where((a) => a.effectiveTo == null || a.effectiveTo!.isAfter(now))
            .map((a) => a.teacherProfileId)
            .toSet()
            .length;

    processStatusNotifier.setSuccess();
    notifyListeners();
  }

  Future<bool> addClassGroup(
    CreateEducationalGroupParams params, {
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => createEducationalGroup.call(params),
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      classes = [...classes, result];
      processStatusNotifier.setSuccess();
      notifyListeners();
      return true;
    }
    processStatusNotifier.setEnabled();
    notifyListeners();
    return false;
  }
}
