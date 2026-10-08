import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class CreateAcademicLevel
    implements AsyncUsecase<AcademicLevel, CreateAcademicLevelParams> {
  final ClassesRepository repository;

  const CreateAcademicLevel({required this.repository});

  @override
  AsyncRequest<AcademicLevel> call(CreateAcademicLevelParams params) {
    return repository.createAcademicLevel(params);
  }
}
