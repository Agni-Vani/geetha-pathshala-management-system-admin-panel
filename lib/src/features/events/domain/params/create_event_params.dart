final class CreateEventParams {
  final String title;
  final String? description;
  final DateTime eventDate;
  final String? time;
  final String scope;
  final String? pathshalaId;
  final String? iconName;

  const CreateEventParams({
    required this.title,
    this.description,
    required this.eventDate,
    this.time,
    this.scope = 'All Pathshalas',
    this.pathshalaId,
    this.iconName,
  });
}
