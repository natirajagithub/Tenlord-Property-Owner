import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dormly_owner_mobile/data/repositories/owner_mock_repository.dart';
import 'package:dormly_owner_mobile/data/services/storage_service.dart';

void main() {
  late OwnerMockRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    repository = OwnerMockRepository();
  });

  group('OwnerMockRepository Tests', () {
    test('sendOtp returns true', () async {
      final res = await repository.sendOtp('9876500000');
      expect(res, true);
    });

    test('verifyOtp saves token and returns auth payload', () async {
      final auth = await repository.verifyOtp('9876500000', '123456');
      expect(auth.accessToken, isNotNull);
      expect(StorageService.hasToken(), true);
    });

    test('getDashboardMetrics returns valid revenue and occupancy', () async {
      final metrics = await repository.getDashboardMetrics();
      expect(metrics.totalCollected, 425000);
      expect(metrics.totalPendingDues, 34000);
      expect(metrics.totalBedsCount, 50);
      expect(metrics.occupiedBedsCount, 46);
    });

    test('getProperties returns managed properties list', () async {
      final properties = await repository.getProperties();
      expect(properties.isNotEmpty, true);
      expect(properties.first.name, 'Skyline Luxury PG');
    });

    test('onboardTenant inserts new tenant into directory', () async {
      final initialTenants = await repository.getTenants();
      final initialCount = initialTenants.length;

      final newTenant = await repository.onboardTenant(
        name: 'Priyanshu Sharma',
        phone: '+91 98765 88776',
        email: 'priyanshu@example.com',
        roomNo: '304',
        bedNo: 'Bed C',
        monthlyRent: 8500,
        depositPaid: 15000,
        guardianName: 'Ramesh Sharma',
        guardianPhone: '+91 98765 11000',
      );

      expect(newTenant.name, 'Priyanshu Sharma');
      final updatedTenants = await repository.getTenants();
      expect(updatedTenants.length, initialCount + 1);
    });

    test('recordPayment adds receipt to ledger', () async {
      final initialLedger = await repository.getRentLedger();
      final initialCount = initialLedger.length;

      final receipt = await repository.recordPayment(
        tenantId: 1,
        tenantName: 'Rahul Sharma',
        roomNo: '304',
        amount: 8500,
        paymentMode: 'UPI (GPay)',
        billingMonth: 'August 2026',
      );

      expect(receipt.tenantName, 'Rahul Sharma');
      expect(receipt.amount, 8500);

      final updatedLedger = await repository.getRentLedger();
      expect(updatedLedger.length, initialCount + 1);
    });
  });
}
