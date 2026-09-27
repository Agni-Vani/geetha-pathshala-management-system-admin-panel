import 'person_enums.dart';

/// Contact method or emergency contact detail attached to a registered person.
abstract class PersonContact {
  const PersonContact();

  String get id;
  String get personId;
  ContactType get type;
  String get label;
  String get value;
  bool get isPrimary;
  DateTime? get verifiedAt;

  /// Whether the contact channel has completed verification.
  bool get isVerified => verifiedAt != null;
}
