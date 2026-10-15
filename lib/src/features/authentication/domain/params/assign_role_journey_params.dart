/// Parameters for the unified multi-step Role Assignment Journey.
final class AssignRoleJourneyParams {
  /// Target role: 'SUPERADMIN', 'PATHSHALA_ADMIN', 'TEACHER', or 'STUDENT'
  final String roleType;

  /// Optional ID of an already registered person.
  final String? personId;

  // Person registry details
  final String legalName;
  final String preferredName;
  final String? primaryPhone;
  final String? primaryEmail;
  final String? gender;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? occupation;
  final String? area;

  // IAM Auth credentials
  final bool enableLogin;
  final String? email;
  final String? password;

  // Role scopes & specifics
  final String? pathshalaId;
  final String? title;
  final String? subject;
  final String? rollNumber;
  final String? groupId;
  final DateTime effectiveFrom;

  const AssignRoleJourneyParams({
    required this.roleType,
    this.personId,
    required this.legalName,
    required this.preferredName,
    this.primaryPhone,
    this.primaryEmail,
    this.gender,
    this.dateOfBirth,
    this.bloodGroup,
    this.occupation,
    this.area,
    this.enableLogin = true,
    this.email,
    this.password,
    this.pathshalaId,
    this.title,
    this.subject,
    this.rollNumber,
    this.groupId,
    required this.effectiveFrom,
  });

  Map<String, dynamic> toJson() {
    return {
      'roleType': roleType,
      'personId': personId,
      'personData': {
        'legalName': legalName,
        'preferredName': preferredName,
        'primaryPhone': primaryPhone,
        'primaryEmail': primaryEmail,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'bloodGroup': bloodGroup,
        'occupation': occupation,
        'area': area,
      },
      'email': email ?? primaryEmail,
      'password': password,
      'enableLogin': enableLogin,
      'pathshalaId': pathshalaId,
      'title': title,
      'subject': subject,
      'rollNumber': rollNumber,
      'groupId': groupId,
      'effectiveFrom': effectiveFrom.toIso8601String(),
    };
  }
}
