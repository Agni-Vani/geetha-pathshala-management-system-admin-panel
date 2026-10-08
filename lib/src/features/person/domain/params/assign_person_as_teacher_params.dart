/// Parameters required to assign a registered person as a teacher at one or more Pathshalas.
final class AssignPersonAsTeacherParams {
  final String personId;
  final String organizationId;
  final List<String> pathshalaIds;
  final String role;
  final String subject;
  final DateTime joinedDate;

  const AssignPersonAsTeacherParams({
    required this.personId,
    required this.organizationId,
    required this.pathshalaIds,
    this.role = 'Teacher',
    this.subject = 'শ্রীমদ্ভগবদ্গীতা',
    required this.joinedDate,
  });
}
