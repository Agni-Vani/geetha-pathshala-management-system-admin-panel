final class UpdatePathshalaParams {
  final String pathshalaId;
  final String name;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String district;
  final String country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final DateTime? startedOn;

  const UpdatePathshalaParams({
    required this.pathshalaId,
    required this.name,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.district,
    this.country = 'Bangladesh',
    this.postalCode,
    this.latitude,
    this.longitude,
    this.startedOn,
  });
}
