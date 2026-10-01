final class CreatePersonWorkExperienceParams {
  final String personId;
  final String organizationName;
  final String roleOrDesignation;
  final String? departmentOrUnit;
  final String engagementType;
  final String? location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isOngoing;
  final String? responsibilities;
  final String? createdByUserId;
  final String createdByRoleAtTime;
  final String createdByNameSnapshot;

  const CreatePersonWorkExperienceParams({
    required this.personId,
    required this.organizationName,
    required this.roleOrDesignation,
    this.departmentOrUnit,
    this.engagementType = 'full_time',
    this.location,
    required this.startDate,
    this.endDate,
    this.isOngoing = false,
    this.responsibilities,
    this.createdByUserId,
    required this.createdByRoleAtTime,
    required this.createdByNameSnapshot,
  });
}
