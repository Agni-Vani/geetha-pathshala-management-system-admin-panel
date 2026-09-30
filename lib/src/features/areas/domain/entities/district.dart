/// Administrative District (Zilla) in Bangladesh.
abstract class District {
  const District();

  String get id;
  String get name;
  String get division;
  String get status;
  DateTime? get createdAt;
  DateTime? get updatedAt;
}
