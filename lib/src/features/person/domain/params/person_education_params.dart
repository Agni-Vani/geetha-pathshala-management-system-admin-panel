final class CreatePersonEducationParams {
  final String personId;
  final String academicLevel;
  final String? disciplineOrGroup;
  final String institutionName;
  final String? governingBoard;
  final int? startYear;
  final int? passingYear;
  final bool isOngoing;
  final String? resultOrScore;
  final String? remarks;
  final String? createdByUserId;
  final String createdByRoleAtTime;
  final String createdByNameSnapshot;

  const CreatePersonEducationParams({
    required this.personId,
    required this.academicLevel,
    this.disciplineOrGroup,
    required this.institutionName,
    this.governingBoard,
    this.startYear,
    this.passingYear,
    this.isOngoing = false,
    this.resultOrScore,
    this.remarks,
    this.createdByUserId,
    required this.createdByRoleAtTime,
    required this.createdByNameSnapshot,
  });
}
