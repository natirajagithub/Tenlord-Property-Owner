import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../models/owner_auth_model.dart';
import '../models/owner_dashboard_model.dart';
import '../models/property_model.dart';
import '../models/room_model.dart';
import '../models/tenant_manage_model.dart';
import '../models/rent_collection_model.dart';
import '../models/complaint_manage_model.dart';
import '../models/staff_model.dart';
import '../services/storage_service.dart';
import 'owner_repository.dart';

class OwnerApiRepository implements OwnerRepository {
  final Dio _dio = ApiClient().dio;

  @override
  Future<bool> sendOtp(String phone) async {
    final response = await _dio.post(
      '/auth/owner/send-otp',
      data: {'phone': phone},
    );
    return response.statusCode == 200;
  }

  @override
  Future<OwnerAuthModel> verifyOtp(String phone, String otpCode) async {
    final response = await _dio.post(
      '/auth/owner/verify-otp',
      data: {'phone': phone, 'otp_code': otpCode},
    );
    final model = OwnerAuthModel.fromJson(response.data as Map<String, dynamic>);
    if (model.accessToken != null) {
      await StorageService.saveToken(model.accessToken!);
      await StorageService.savePhone(phone);
    }
    return model;
  }

  @override
  Future<OwnerAuthModel> loginWithEmail(String email, String password) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    final model = OwnerAuthModel.fromJson(response.data as Map<String, dynamic>);
    if (model.accessToken != null) {
      await StorageService.saveToken(model.accessToken!);
    }
    return model;
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (_) {}
    await StorageService.clearSession();
  }

  @override
  Future<OwnerDashboardModel> getDashboardMetrics() async {
    final response = await _dio.get(ApiEndpoints.ownerDashboard);
    return OwnerDashboardModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<PropertyModel>> getProperties() async {
    final response = await _dio.get(ApiEndpoints.ownerProperties);
    if (response.data is List) {
      return (response.data as List)
          .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<RoomModel>> getRoomsByProperty(int propertyId) async {
    final response = await _dio.get(
      ApiEndpoints.ownerRooms,
      queryParameters: {'property_id': propertyId},
    );
    if (response.data is List) {
      return (response.data as List)
          .map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<TenantManageModel>> getTenants() async {
    final response = await _dio.get(ApiEndpoints.ownerTenants);
    if (response.data is List) {
      return (response.data as List)
          .map((e) => TenantManageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
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
  }) async {
    final response = await _dio.post(
      ApiEndpoints.ownerTenants,
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'room_no': roomNo,
        'bed_no': bedNo,
        'monthly_rent': monthlyRent,
        'deposit_paid': depositPaid,
        'guardian_name': guardianName,
        'guardian_phone': guardianPhone,
      },
    );
    return TenantManageModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<RentCollectionModel>> getRentLedger() async {
    final response = await _dio.get(ApiEndpoints.ownerInvoices);
    if (response.data is List) {
      return (response.data as List)
          .map((e) => RentCollectionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<RentCollectionModel> recordPayment({
    required int tenantId,
    required String tenantName,
    required String roomNo,
    required num amount,
    required String paymentMode,
    required String billingMonth,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.ownerInvoices,
      data: {
        'tenant_id': tenantId,
        'tenant_name': tenantName,
        'room_no': roomNo,
        'amount': amount,
        'payment_mode': paymentMode,
        'billing_month': billingMonth,
      },
    );
    return RentCollectionModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<ComplaintManageModel>> getComplaints() async {
    final response = await _dio.get(ApiEndpoints.ownerComplaints);
    if (response.data is List) {
      return (response.data as List)
          .map((e) => ComplaintManageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<StaffModel>> getStaffList() async {
    final response = await _dio.get(ApiEndpoints.ownerStaff);
    if (response.data is List) {
      return (response.data as List)
          .map((e) => StaffModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<bool> assignStaffToComplaint(int complaintId, int staffId, String staffName) async {
    final response = await _dio.post(
      '${ApiEndpoints.ownerComplaints}/$complaintId',
      data: {'staff_id': staffId, 'status': 'In Progress'},
    );
    return response.statusCode == 200;
  }

  @override
  Future<bool> resolveComplaint(int complaintId) async {
    final response = await _dio.post(
      '${ApiEndpoints.ownerComplaints}/$complaintId',
      data: {'status': 'Resolved'},
    );
    return response.statusCode == 200;
  }
}
