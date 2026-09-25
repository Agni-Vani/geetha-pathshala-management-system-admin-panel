/// Administrative Upazila / Thana (sub-district) in Bangladesh.
abstract class Upazila {
  const Upazila();

  String get id;
  String get districtId;
  String get name;
  String get status;
  DateTime? get createdAt;
  DateTime? get updatedAt;
}
