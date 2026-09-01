import 'package:flutter/material.dart';
import '../../data/models/owner_dashboard_model.dart';
import '../../data/models/property_model.dart';
import '../../data/models/tenant_manage_model.dart';
import '../../data/repositories/owner_repository.dart';

class OwnerDashboardViewModel extends ChangeNotifier {
  final OwnerRepository repository;

  OwnerDashboardViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OwnerDashboardModel? _metrics;
  OwnerDashboardModel? get metrics => _metrics;

  List<PropertyModel> _properties = [];
  List<PropertyModel> get properties => _properties;

  PropertyModel? _selectedProperty;
  PropertyModel? get selectedProperty => _selectedProperty;

  List<TenantManageModel> _overdueTenants = [];
  List<TenantManageModel> get overdueTenants => _overdueTenants;

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getDashboardMetrics(),
        repository.getProperties(),
        repository.getTenants(),
      ]);

      _metrics = results[0] as OwnerDashboardModel;
      _properties = results[1] as List<PropertyModel>;
      if (_properties.isNotEmpty && _selectedProperty == null) {
        _selectedProperty = _properties.first;
      }

      final tenantsList = results[2] as List<TenantManageModel>;
      _overdueTenants = tenantsList.where((t) => t.paymentStatus == 'Overdue' || t.paymentStatus == 'Due').toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectProperty(PropertyModel prop) {
    _selectedProperty = prop;
    notifyListeners();
  }
}
