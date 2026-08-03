import 'registry_enums.dart';

/// Governance committee registered at central or Pathshala scope.
abstract class Committee {
  const Committee();

  String get id;
  String get organizationId;
  String? get pathshalaId;
  String get name;
  CommitteeType get type;
  CommitteeStatus get status;

  /// Whether this committee belongs to central governance.
  bool get isCentral => type == CommitteeType.central;

  /// Whether this committee is attached to a specific Pathshala.
  bool get isPathshalaScoped => pathshalaId != null;
}
