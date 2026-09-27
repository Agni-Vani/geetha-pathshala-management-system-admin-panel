abstract class Event {
  const Event();

  String get id;
  String get title;
  String get description;
  DateTime get eventDate;
  String get time;
  String get scope;
  String? get iconName;
}
