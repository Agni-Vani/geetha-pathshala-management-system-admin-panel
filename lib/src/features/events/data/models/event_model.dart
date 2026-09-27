import '../../domain/entities/entities.dart';

class EventModel extends Event {
  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime eventDate;
  @override
  final String time;
  @override
  final String scope;
  @override
  final String? iconName;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.time,
    required this.scope,
    this.iconName,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      time: json['time'] as String,
      scope: json['scope'] as String,
      iconName: json['iconName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'eventDate': eventDate.toIso8601String(),
    'time': time,
    'scope': scope,
    'iconName': iconName,
  };
}
