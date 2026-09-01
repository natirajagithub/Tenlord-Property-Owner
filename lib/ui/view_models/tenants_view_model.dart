import 'package:flutter/material.dart';
import '../../data/models/tenant_manage_model.dart';
import '../../data/repositories/owner_repository.dart';

class TenantsViewModel extends ChangeNotifier {
  final OwnerRepository repository;

  TenantsViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  List<TenantManageModel> _tenants = [];
  List<TenantManageModel> get tenants => _tenants;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<TenantManageModel> get filteredTenants {
    if (_searchQuery.trim().isEmpty) return _tenants;
    final q = _searchQuery.toLowerCase().trim();
    return _tenants.where((t) {
      return t.name.toLowerCase().contains(q) ||
          t.phone.contains(q) ||
          t.roomNo.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> loadTenants() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tenants = await repository.getTenants();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  Future<bool> onboardTenant({
    required String name,
    required String phone,
    required String email,
    required String roomNo,
    required String bedNo,
    required num monthlyRent,
    required num depositPaid,
    required String guardianName,
    required String guardianPhone,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final newTenant = await repository.onboardTenant(
        name: name,
        phone: phone,
        email: email,
        roomNo: roomNo,
        bedNo: bedNo,
        monthlyRent: monthlyRent,
        depositPaid: depositPaid,
        guardianName: guardianName,
        guardianPhone: guardianPhone,
      );
      _tenants.insert(0, newTenant);
      return true;
    } catch (_) {
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
