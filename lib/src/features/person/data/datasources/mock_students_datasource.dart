import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'students_datasource.dart';

final class MockStudentsDatasource implements StudentsDatasource {
  final Duration processingDelay;
  final List<StudentAdmissionModel> _admissions;
  final List<StudentTransferModel> _transfers;
  final List<StudentModel> _students;

  MockStudentsDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _admissions = _seedAdmissions(),
       _transfers = [],
       _students = _seedStudents();

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

  @override
  Future<List<StudentModel>> listStudents(ListStudentsParams params) async {
    await _simulateProcessing();
    return _students.where((s) {
      if (params.studentClass != null &&
          params.studentClass != 'All Classes' &&
          s.studentClass != params.studentClass) {
        return false;
      }
      if (params.pathshalaId != null &&
          params.pathshalaId != 'All Pathshalas' &&
          s.pathshala != params.pathshalaId) {
        return false;
      }
      if (params.search != null && params.search!.trim().isNotEmpty) {
        final query = params.search!.trim().toLowerCase();
        final match = s.name.toLowerCase().contains(query) ||
            s.roll.toLowerCase().contains(query) ||
            s.studentClass.toLowerCase().contains(query);
        if (!match) return false;
      }
      return true;
    }).toList();
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

  static List<StudentModel> _seedStudents() {
    return [
      const StudentModel(
        id: 'std-001',
        name: 'অনন্যা শর্মা',
        studentClass: 'শ্রেণি ৫',
        pathshala: 'Chattogram North Gita Pathshala',
        roll: 'CTG-05-01',
        isActive: true,
      ),
      const StudentModel(
        id: 'std-002',
        name: 'বিবান পাটেল',
        studentClass: 'শ্রেণি ৬',
        pathshala: 'Dhaka Central Gita Pathshala',
        roll: 'DHK-06-02',
        isActive: true,
      ),
      const StudentModel(
        id: 'std-003',
        name: 'ইশিকা ভার্মা',
        studentClass: 'শ্রেণি ৪',
        pathshala: 'Sylhet East Gita Pathshala',
        roll: 'SYL-04-03',
        isActive: true,
      ),
      const StudentModel(
        id: 'std-004',
        name: 'কৃষ্ণ তিওয়ারি',
        studentClass: 'শ্রেণি ৭',
        pathshala: 'Chattogram North Gita Pathshala',
        roll: 'CTG-07-04',
        isActive: true,
      ),
      const StudentModel(
        id: 'std-005',
        name: 'মায়রা জোশী',
        studentClass: 'শ্রেণি ৩',
        pathshala: 'Dhaka Central Gita Pathshala',
        roll: 'DHK-03-05',
        isActive: false,
      ),
      const StudentModel(
        id: 'std-006',
        name: 'অর্জুন সিং',
        studentClass: 'শ্রেণি ৫',
        pathshala: 'Sylhet East Gita Pathshala',
        roll: 'SYL-05-06',
        isActive: true,
      ),
    ];
  }
}
