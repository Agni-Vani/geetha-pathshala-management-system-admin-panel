import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'students_datasource.dart';

final class MockStudentsDatasource implements StudentsDatasource {
  final Duration processingDelay;
  final List<StudentAdmissionModel> _admissions;
  final List<StudentTransferModel> _transfers;

  MockStudentsDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _admissions = _seedAdmissions(),
       _transfers = [];

  @override
  Future<StudentAdmissionModel> admitStudent(AdmitStudentParams params) async {
    await _simulateProcessing();
    final admission = StudentAdmissionModel(
      id: 'adm-${DateTime.now().millisecondsSinceEpoch}',
      organizationId: params.organizationId,
      pathshalaId: params.pathshalaId,
      personId: params.personId,
      rollNumber: params.rollNumber,
      admissionDate: DateTime.now(),
      status: AdmissionStatus.active,
      createdAt: DateTime.now(),
    );
    _admissions.add(admission);
    return admission;
  }

  @override
  Future<StudentTransferModel> transferStudent(
    TransferStudentParams params,
  ) async {
    await _simulateProcessing();
    final transfer = StudentTransferModel(
      id: 'trf-${DateTime.now().millisecondsSinceEpoch}',
      personId: params.personId,
      fromPathshalaId: params.fromPathshalaId,
      toPathshalaId: params.toPathshalaId,
      requestedDate: DateTime.now(),
      status: TransferStatus.requested,
      reason: params.reason,
      approvedByUserId: null,
    );
    _transfers.add(transfer);
    return transfer;
  }

  @override
  Future<List<StudentAdmissionModel>> listStudentAdmissions(
    ListStudentAdmissionsParams params,
  ) async {
    await _simulateProcessing();
    return _admissions
        .where((a) => a.pathshalaId == params.pathshalaId)
        .toList();
  }

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }

  static List<StudentAdmissionModel> _seedAdmissions() {
    return [
      StudentAdmissionModel(
        id: 'adm-rishav-dhaka',
        organizationId: 'org-gp-central',
        pathshalaId: 'pathshala-dhaka-central',
        personId: 'person-rishav-roy',
        rollNumber: 'DHK-001-R01',
        admissionDate: DateTime(2026, 7, 5),
        status: AdmissionStatus.active,
        createdAt: DateTime(2026, 7, 5),
      ),
    ];
  }
}
