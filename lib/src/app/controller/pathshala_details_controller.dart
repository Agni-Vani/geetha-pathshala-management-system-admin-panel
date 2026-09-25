import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/utils/utils.dart';
import 'package:geetha_pathshala_management_web/src/features/communication/domain/communication_domain.dart';
import 'package:geetha_pathshala_management_web/src/features/education/domain/education_domain.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/domain/registry_domain.dart';

/// A resolved committee member: the raw [membership] paired with the
/// [person] it points to, so views don't need a second lookup.
final class PathshalaAdministrator {
  final Person person;
  final CommitteeMembership membership;

  const PathshalaAdministrator({required this.person, required this.membership});
}

class PathshalaDetailsController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(initialStatus: ProcessEnabled());

  final ListCommittees listCommittees;
  final ListCommitteeMemberships listCommitteeMemberships;
  final GetPersonById getPersonById;
  final GetNotices getNotices;
  final ListStudentAdmissions listStudentAdmissions;
  final ListTeacherAssignments listTeacherAssignments;

  PathshalaDetailsController({
    required this.listCommittees,
    required this.listCommitteeMemberships,
    required this.getPersonById,
    required this.getNotices,
    required this.listStudentAdmissions,
    required this.listTeacherAssignments,
  });

  List<PathshalaAdministrator> administrators = [];
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

    final now = DateTime.now();

    administrators = resolvedAdministrators;
    noticesCount = notices.length;
    studentsCount = admissions.where((a) => a.status == AdmissionStatus.active).length;
    teachersCount = assignments
        .where((a) => a.effectiveTo == null || a.effectiveTo!.isAfter(now))
        .map((a) => a.teacherProfileId)
        .toSet()
        .length;

    processStatusNotifier.setSuccess();
    notifyListeners();
  }
}
