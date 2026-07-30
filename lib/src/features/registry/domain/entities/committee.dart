import 'registry_enums.dart';

abstract class Committee {
  const Committee();

  String get id;
  String get organizationId;
  String? get pathshalaId;
  String get name;
  CommitteeType get type;
  CommitteeStatus get status;

  bool get isCentral => type == CommitteeType.central;
  bool get isPathshalaScoped => pathshalaId != null;
}
