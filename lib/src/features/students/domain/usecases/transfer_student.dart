import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class TransferStudent
    implements AsyncUsecase<StudentTransfer, TransferStudentParams> {
  final StudentsRepository repository;

  const TransferStudent({required this.repository});

  @override
  AsyncRequest<StudentTransfer> call(TransferStudentParams params) {
    return repository.transferStudent(params);
  }
}
