import '../models/owner_auth_model.dart';
import '../models/owner_dashboard_model.dart';
import '../models/property_model.dart';
import '../models/room_model.dart';
import '../models/tenant_manage_model.dart';
import '../models/rent_collection_model.dart';
import '../models/complaint_manage_model.dart';
import '../models/staff_model.dart';

abstract class OwnerRepository {
  // Auth
  Future<bool> sendOtp(String phone);
  Future<OwnerAuthModel> verifyOtp(String phone, String otpCode);
  Future<OwnerAuthModel> loginWithEmail(String email, String password);
  Future<void> logout();

  // Dashboard & Properties
  Future<OwnerDashboardModel> getDashboardMetrics();
  Future<List<PropertyModel>> getProperties();
  Future<List<RoomModel>> getRoomsByProperty(int propertyId);

  // Tenants
  Future<List<TenantManageModel>> getTenants();
  Future<TenantManageModel> onboardTenant({
    required String name,
    required String phone,
    required String email,
    required String roomNo,
    required String bedNo,
    required num monthlyRent,
    required num depositPaid,
    required String guardianName,
    required String guardianPhone,
  });

  // Financial Ledger
  Future<List<RentCollectionModel>> getRentLedger();
  Future<RentCollectionModel> recordPayment({
    required int tenantId,
    required String tenantName,
    required String roomNo,
    required num amount,
    required String paymentMode,
    required String billingMonth,
  });

  // Complaints & Staff
  Future<List<ComplaintManageModel>> getComplaints();
  Future<List<StaffModel>> getStaffList();
  Future<bool> assignStaffToComplaint(int complaintId, int staffId, String staffName);
  Future<bool> resolveComplaint(int complaintId);
}
