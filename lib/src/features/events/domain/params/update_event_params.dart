final class UpdateEventParams {
  final String id;
  final String title;
  final String? description;
  final DateTime eventDate;
  final String? time;
  final String scope;
  final String? pathshalaId;
  final String? iconName;

  const UpdateEventParams({
    required this.id,
    required this.title,
    this.description,
    required this.eventDate,
    this.time,
    this.scope = 'All Pathshalas',
    this.pathshalaId,
    this.iconName,
  });
}
