import 'registry_enums.dart';

/// Authoritative registry record for a local Gita Pathshala.
abstract class Pathshala {
  const Pathshala();

  String get id;
  String get organizationId;
  String get code;
  String get name;
  PathshalaStatus get status;
  PathshalaAddress get address;
  GeoCoordinate? get coordinate;
  DateTime? get startedOn;
  DateTime? get closedOn;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Whether the Pathshala is currently available for local operations.
  bool get isOperational => status == PathshalaStatus.active;
}

/// Structured address for a registered Pathshala.
abstract class PathshalaAddress {
  const PathshalaAddress();

  String get addressLine1;
  String? get addressLine2;
  String get city;
  String get region;
  String get country;
  String? get postalCode;

  /// Human-readable address assembled from available address parts.
  String get formatted {
    final parts = [
      addressLine1,
      addressLine2,
      city,
      region,
      postalCode,
      country,
    ];
    return parts
        .where((part) => part != null && part.trim().isNotEmpty)
        .join(', ');
  }
}

/// Geographic coordinate for optional map and distance-based features.
abstract class GeoCoordinate {
  const GeoCoordinate();

  double get latitude;
  double get longitude;
}
