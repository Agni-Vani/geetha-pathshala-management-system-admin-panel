import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/pathshala_repository.dart';
import '../datasources/pathshala_datasource.dart';

final class PathshalaRepositoryImpl
    with ErrorHandler
    implements PathshalaRepository {
  final PathshalaDatasource datasource;

  const PathshalaRepositoryImpl(this.datasource);

  @override
  AsyncRequest<Pathshala> createPathshala(CreatePathshalaParams params) {
    return _request(() => datasource.createPathshala(params));
  }

  @override
  AsyncRequest<Pathshala> getPathshalaById(String id) {
    return _request(() => datasource.getPathshalaById(id));
  }

  @override
  AsyncRequest<List<Pathshala>> listPathshalas(ListPathshalasParams params) {
    return _request(() => datasource.listPathshalas(params));
  }

  @override
  AsyncRequest<Pathshala> updatePathshala(UpdatePathshalaParams params) {
    return _request(() => datasource.updatePathshala(params));
  }

  @override
  AsyncRequest<Organization> getOrganization(String id) {
    return _request(() => datasource.getOrganization(id));
  }

  @override
  AsyncRequest<Committee> getCommitteeById(String id) {
    return _request(() => datasource.getCommitteeById(id));
  }

  @override
  AsyncRequest<List<Committee>> listCommittees(ListCommitteesParams params) {
    return _request(() => datasource.listCommittees(params));
  }

  @override
  AsyncRequest<List<CommitteeMembership>> listCommitteeMemberships(
    ListCommitteeMembershipsParams params,
  ) {
    return _request(() => datasource.listCommitteeMemberships(params));
  }

  AsyncRequest<T> _request<T>(Future<T> Function() request) {
    return asyncTryCatch<T>(
      tryFunc: () async {
        final data = await request();
        return SuccessRepoCall<T>(data: data);
      },
    );
  }
}
