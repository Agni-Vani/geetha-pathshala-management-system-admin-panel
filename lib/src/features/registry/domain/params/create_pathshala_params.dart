import '../entities/entities.dart';

final class CreatePathshalaParams {
  final String organizationId;
  final String code;
  final String name;
  final PathshalaAddress address;
  final GeoCoordinate? coordinate;
  final DateTime? startedOn;

  const CreatePathshalaParams({
    required this.organizationId,
    required this.code,
    required this.name,
    required this.address,
    this.coordinate,
    this.startedOn,
  });
}
