import 'iam_enums.dart';

/// User account entity linking Supabase Auth and Person registry identifier.
abstract class UserAccount {
  const UserAccount();

  String get id;
  String get personId;
  String? get authUserId;
  String get email;
  AccountStatus get status;
  DateTime get createdAt;
  DateTime get updatedAt;

  bool get isActive => status == AccountStatus.active;
}
