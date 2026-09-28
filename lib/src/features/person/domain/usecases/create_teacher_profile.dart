import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class CreateTeacherProfile
    implements AsyncUsecase<TeacherProfile, CreateTeacherProfileParams> {
  final TeachersRepository repository;

  const CreateTeacherProfile({required this.repository});

  @override
  AsyncRequest<TeacherProfile> call(CreateTeacherProfileParams params) {
    return repository.createTeacherProfile(params);
  }
}
