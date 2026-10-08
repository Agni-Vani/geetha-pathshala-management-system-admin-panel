import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Admits a registered person as a student of a Pathshala.
final class AdmitPersonAsStudent implements AsyncUsecase<void, AdmitPersonAsStudentParams> {
  final PersonRepository repository;

  const AdmitPersonAsStudent(this.repository);

  @override
  AsyncRequest<void> call(AdmitPersonAsStudentParams params) {
    return repository.admitPersonAsStudent(params);
  }
}
