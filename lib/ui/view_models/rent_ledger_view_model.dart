import 'package:flutter/material.dart';
import '../../data/models/rent_collection_model.dart';
import '../../data/repositories/owner_repository.dart';

class RentLedgerViewModel extends ChangeNotifier {
  final OwnerRepository repository;

  RentLedgerViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  List<RentCollectionModel> _ledger = [];
  List<RentCollectionModel> get ledger => _ledger;

  num get totalCollected =>
      _ledger.where((l) => l.status == 'Paid').fold(0, (sum, l) => sum + l.amount);

  Future<void> loadLedger() async {
    _isLoading = true;
    notifyListeners();

    try {
      _ledger = await repository.getRentLedger();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> recordPayment({
    required int tenantId,
    required String tenantName,
    required String roomNo,
    required num amount,
    required String paymentMode,
    required String billingMonth,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final receipt = await repository.recordPayment(
        tenantId: tenantId,
        tenantName: tenantName,
        roomNo: roomNo,
        amount: amount,
        paymentMode: paymentMode,
        billingMonth: billingMonth,
      );
      _ledger.insert(0, receipt);
      return true;
    } catch (_) {
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
