import 'registry_enums.dart';

abstract class PersonContact {
  const PersonContact();

  String get id;
  String get personId;
  ContactType get type;
  String get label;
  String get value;
  bool get isPrimary;
  DateTime? get verifiedAt;

  bool get isVerified => verifiedAt != null;
}
