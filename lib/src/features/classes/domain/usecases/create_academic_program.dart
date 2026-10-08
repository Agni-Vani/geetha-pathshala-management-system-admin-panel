import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class CreateAcademicProgram
    implements AsyncUsecase<AcademicProgram, CreateAcademicProgramParams> {
  final ClassesRepository repository;

  const CreateAcademicProgram({required this.repository});

  @override
  AsyncRequest<AcademicProgram> call(CreateAcademicProgramParams params) {
    return repository.createAcademicProgram(params);
  }
}
