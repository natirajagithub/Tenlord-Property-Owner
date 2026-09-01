import 'package:flutter/material.dart';
import '../../data/models/complaint_manage_model.dart';
import '../../data/models/staff_model.dart';
import '../../data/repositories/owner_repository.dart';

class ComplaintsManageViewModel extends ChangeNotifier {
  final OwnerRepository repository;

  ComplaintsManageViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ComplaintManageModel> _complaints = [];
  List<ComplaintManageModel> get complaints => _complaints;

  List<StaffModel> _staffList = [];
  List<StaffModel> get staffList => _staffList;

  List<ComplaintManageModel> get pendingComplaints =>
      _complaints.where((c) => c.status != 'Resolved').toList();

  List<ComplaintManageModel> get resolvedComplaints =>
      _complaints.where((c) => c.status == 'Resolved').toList();

  Future<void> loadComplaintsAndStaff() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getComplaints(),
        repository.getStaffList(),
      ]);
      _complaints = results[0] as List<ComplaintManageModel>;
      _staffList = results[1] as List<StaffModel>;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> assignStaff(int complaintId, int staffId, String staffName) async {
    final success = await repository.assignStaffToComplaint(complaintId, staffId, staffName);
    if (success) {
      await loadComplaintsAndStaff();
    }
    return success;
  }

  Future<bool> resolveTicket(int complaintId) async {
    final success = await repository.resolveComplaint(complaintId);
    if (success) {
      await loadComplaintsAndStaff();
    }
    return success;
  }
}
