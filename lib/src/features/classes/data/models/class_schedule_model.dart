import '../../domain/entities/entities.dart';

class ClassScheduleModel extends ClassSchedule {
  @override
  final String id;
  @override
  final String subject;
  @override
  final String day;
  @override
  final String time;
  @override
  final String teacher;
  @override
  final String? pathshalaId;

  const ClassScheduleModel({
    required this.id,
    required this.subject,
    required this.day,
    required this.time,
    required this.teacher,
    this.pathshalaId,
  });

  factory ClassScheduleModel.fromJson(Map<String, dynamic> json) {
    return ClassScheduleModel(
      id: json['id'] as String,
      subject: json['subject'] as String,
      day: json['day'] as String,
      time: json['time'] as String,
      teacher: json['teacher'] as String,
      pathshalaId: json['pathshalaId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'day': day,
    'time': time,
    'teacher': teacher,
    'pathshalaId': pathshalaId,
  };
}
