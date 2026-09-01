import 'dart:async';
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

class OwnerMockRepository implements OwnerRepository {
  final List<TenantManageModel> _tenants = [
    TenantManageModel(
      id: 1,
      name: 'Rahul Sharma',
      phone: '+91 98765 43210',
      email: 'rahul.sharma@example.com',
      propertyName: 'Skyline Luxury PG',
      roomNo: '304',
      bedNo: 'Bed B',
      monthlyRent: 8500,
      depositPaid: 15000,
      joinDate: '2026-06-01',
      rentDueDate: '2026-08-25',
      paymentStatus: 'Due',
      guardianName: 'Rajesh Sharma (Father)',
      guardianPhone: '+91 98765 00999',
    ),
    TenantManageModel(
      id: 2,
      name: 'Aman Verma',
      phone: '+91 98765 11223',
      email: 'aman.verma@example.com',
      propertyName: 'Skyline Luxury PG',
      roomNo: '304',
      bedNo: 'Bed A',
      monthlyRent: 8500,
      depositPaid: 15000,
      joinDate: '2026-05-15',
      rentDueDate: '2026-08-05',
      paymentStatus: 'Overdue',
      guardianName: 'Suresh Verma (Father)',
      guardianPhone: '+91 98765 00888',
    ),
    TenantManageModel(
      id: 3,
      name: 'Vikramaditya Roy',
      phone: '+91 98765 99887',
      email: 'vikram.roy@example.com',
      propertyName: 'Skyline Luxury PG',
      roomNo: '101',
      bedNo: 'Bed A',
      monthlyRent: 9500,
      depositPaid: 18000,
      joinDate: '2026-01-10',
      rentDueDate: '2026-08-01',
      paymentStatus: 'Paid',
      guardianName: 'Anindya Roy (Father)',
      guardianPhone: '+91 98765 00777',
    ),
    TenantManageModel(
      id: 4,
      name: 'Ketan Patel',
      phone: '+91 98765 55443',
      email: 'ketan.patel@example.com',
      propertyName: 'Skyline Luxury PG',
      roomNo: '201',
      bedNo: 'Bed B',
      monthlyRent: 8000,
      depositPaid: 16000,
      joinDate: '2026-03-01',
      rentDueDate: '2026-08-03',
      paymentStatus: 'Paid',
      guardianName: 'Nitin Patel (Father)',
      guardianPhone: '+91 98765 00666',
    ),
  ];

  final List<RentCollectionModel> _rentLedger = [
    RentCollectionModel(
      id: 1,
      receiptNo: 'REC-2026-08-001',
      tenantName: 'Vikramaditya Roy',
      roomNo: '101',
      billingMonth: 'August 2026',
      amount: 9500,
      paymentDate: '2026-08-01',
      paymentMode: 'UPI (GPay)',
      status: 'Paid',
    ),
    RentCollectionModel(
      id: 2,
      receiptNo: 'REC-2026-08-002',
      tenantName: 'Ketan Patel',
      roomNo: '201',
      billingMonth: 'August 2026',
      amount: 8000,
      paymentDate: '2026-08-03',
      paymentMode: 'Bank Transfer',
      status: 'Paid',
    ),
    RentCollectionModel(
      id: 3,
      receiptNo: 'REC-2026-07-042',
      tenantName: 'Rahul Sharma',
      roomNo: '304',
      billingMonth: 'July 2026',
      amount: 8500,
      paymentDate: '2026-07-03',
      paymentMode: 'UPI (PhonePe)',
      status: 'Paid',
    ),
  ];

  final List<ComplaintManageModel> _complaints = [
    ComplaintManageModel(
      id: 101,
      tenantName: 'Rahul Sharma',
      roomNo: '304',
      title: 'AC remote not working / battery leak',
      category: 'Electricity / AC',
      priority: 'Normal',
      status: 'In Progress',
      assignedStaffName: 'Ramesh (Electrician)',
      assignedStaffPhone: '+91 98765 22334',
      createdAt: '2026-08-18 11:30 AM',
      description: 'The remote displays nothing on screen and room AC cannot be turned on.',
    ),
    ComplaintManageModel(
      id: 102,
      tenantName: 'Aman Verma',
      roomNo: '304',
      title: 'Geyser low pressure and slow heating',
      category: 'Plumbing',
      priority: 'Urgent',
      status: 'Pending',
      createdAt: '2026-08-19 08:15 AM',
      description: 'Water pressure from hot outlet is extremely low.',
    ),
  ];

  final List<StaffModel> _staffList = [
    StaffModel(id: 1, name: 'Suresh Kumar', role: 'PG Warden', phone: '+91 98765 00123'),
    StaffModel(id: 2, name: 'Ramesh Singh', role: 'Electrician & AC Tech', phone: '+91 98765 22334'),
    StaffModel(id: 3, name: 'Mahesh Sharma', role: 'Plumber', phone: '+91 98765 33445'),
    StaffModel(id: 4, name: 'Anita Devi', role: 'Head Housekeeper', phone: '+91 98765 44556'),
  ];

  @override
  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<OwnerAuthModel> verifyOtp(String phone, String otpCode) async {
    await Future.delayed(const Duration(milliseconds: 600));
    const token = 'mock_jwt_owner_token_123456';
    await StorageService.saveToken(token);
    await StorageService.savePhone(phone);

    return OwnerAuthModel(
      accessToken: token,
      message: 'Owner Auth Successful',
      ownerUser: {
        'id': 1,
        'full_name': 'Natiraj PS (Owner)',
        'phone': phone,
        'role': 'owner',
        'business_name': 'Dormly Hospitality & PG Network',
      },
    );
  }

  @override
  Future<OwnerAuthModel> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    const token = 'mock_jwt_owner_token_123456';
    await StorageService.saveToken(token);

    return OwnerAuthModel(
      accessToken: token,
      message: 'Owner Login Successful',
      ownerUser: {
        'id': 1,
        'full_name': 'Natiraj PS (Owner)',
        'email': email,
        'role': 'owner',
        'business_name': 'Dormly Hospitality & PG Network',
      },
    );
  }

  @override
  Future<void> logout() async {
    await StorageService.clearSession();
  }

  @override
  Future<OwnerDashboardModel> getDashboardMetrics() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return OwnerDashboardModel(
      totalRevenue: 459000,
      totalCollected: 425000,
      totalPendingDues: 34000,
      totalPropertiesCount: 2,
      totalRoomsCount: 20,
      totalBedsCount: 50,
      occupiedBedsCount: 46,
      vacantBedsCount: 4,
      pendingComplaintsCount: _complaints.where((c) => c.status == 'Pending').length,
      overdueTenantsCount: _tenants.where((t) => t.paymentStatus == 'Overdue').length,
    );
  }

  @override
  Future<List<PropertyModel>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      PropertyModel(
        id: 1,
        name: 'Skyline Luxury PG',
        address: 'Koramangala 4th Block',
        city: 'Bengaluru',
        totalFloors: 4,
        totalRooms: 12,
        totalBeds: 30,
        occupiedBeds: 28,
        wardenName: 'Suresh Kumar',
        wardenPhone: '+91 98765 00123',
      ),
      PropertyModel(
        id: 2,
        name: 'Green View Student Hostel',
        address: 'HSR Layout Sector 1',
        city: 'Bengaluru',
        totalFloors: 3,
        totalRooms: 8,
        totalBeds: 20,
        occupiedBeds: 18,
        wardenName: 'Rajesh Verma',
        wardenPhone: '+91 98765 00444',
      ),
    ];
  }

  @override
  Future<List<RoomModel>> getRoomsByProperty(int propertyId) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return [
      RoomModel(
        id: 101,
        floorNo: 1,
        roomNo: '101',
        roomType: 'Single Sharing (AC)',
        isAc: true,
        monthlyRent: 9500,
        beds: [
          BedModel(id: 1, bedNo: 'Bed A', status: 'Occupied', tenantName: 'Vikramaditya Roy', tenantPhone: '+91 98765 99887'),
        ],
      ),
      RoomModel(
        id: 102,
        floorNo: 1,
        roomNo: '102',
        roomType: '2-Sharing (Non-AC)',
        isAc: false,
        monthlyRent: 7500,
        beds: [
          BedModel(id: 2, bedNo: 'Bed A', status: 'Occupied', tenantName: 'Rohit Gupta', tenantPhone: '+91 98765 44332'),
          BedModel(id: 3, bedNo: 'Bed B', status: 'Vacant'),
        ],
      ),
      RoomModel(
        id: 201,
        floorNo: 2,
        roomNo: '201',
        roomType: '2-Sharing (AC)',
        isAc: true,
        monthlyRent: 8000,
        beds: [
          BedModel(id: 4, bedNo: 'Bed A', status: 'Occupied', tenantName: 'Ketan Patel', tenantPhone: '+91 98765 55443'),
          BedModel(id: 5, bedNo: 'Bed B', status: 'Occupied', tenantName: 'Manish Shah', tenantPhone: '+91 98765 66778'),
        ],
      ),
      RoomModel(
        id: 304,
        floorNo: 3,
        roomNo: '304',
        roomType: '2-Sharing (AC)',
        isAc: true,
        monthlyRent: 8500,
        beds: [
          BedModel(id: 6, bedNo: 'Bed A', status: 'Occupied', tenantName: 'Aman Verma', tenantPhone: '+91 98765 11223'),
          BedModel(id: 7, bedNo: 'Bed B', status: 'Occupied', tenantName: 'Rahul Sharma', tenantPhone: '+91 98765 43210'),
        ],
      ),
    ];
  }

  @override
  Future<List<TenantManageModel>> getTenants() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_tenants);
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
    await Future.delayed(const Duration(milliseconds: 600));
    final newTenant = TenantManageModel(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      name: name,
      phone: phone,
      email: email,
      propertyName: 'Skyline Luxury PG',
      roomNo: roomNo,
      bedNo: bedNo,
      monthlyRent: monthlyRent,
      depositPaid: depositPaid,
      joinDate: 'Today',
      rentDueDate: '2026-09-05',
      paymentStatus: 'Paid',
      guardianName: guardianName,
      guardianPhone: guardianPhone,
    );
    _tenants.insert(0, newTenant);
    return newTenant;
  }

  @override
  Future<List<RentCollectionModel>> getRentLedger() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_rentLedger);
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
    await Future.delayed(const Duration(milliseconds: 500));
    final newReceipt = RentCollectionModel(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      receiptNo: 'REC-2026-08-${(DateTime.now().millisecondsSinceEpoch % 900) + 100}',
      tenantName: tenantName,
      roomNo: roomNo,
      billingMonth: billingMonth,
      amount: amount,
      paymentDate: 'Today',
      paymentMode: paymentMode,
      status: 'Paid',
    );
    _rentLedger.insert(0, newReceipt);

    // Update tenant status to Paid
    final index = _tenants.indexWhere((t) => t.id == tenantId || t.name == tenantName);
    if (index != -1) {
      final old = _tenants[index];
      _tenants[index] = TenantManageModel(
        id: old.id,
        name: old.name,
        phone: old.phone,
        email: old.email,
        propertyName: old.propertyName,
        roomNo: old.roomNo,
        bedNo: old.bedNo,
        monthlyRent: old.monthlyRent,
        depositPaid: old.depositPaid,
        joinDate: old.joinDate,
        rentDueDate: old.rentDueDate,
        paymentStatus: 'Paid',
        guardianName: old.guardianName,
        guardianPhone: old.guardianPhone,
      );
    }

    return newReceipt;
  }

  @override
  Future<List<ComplaintManageModel>> getComplaints() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_complaints);
  }

  @override
  Future<List<StaffModel>> getStaffList() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_staffList);
  }

  @override
  Future<bool> assignStaffToComplaint(int complaintId, int staffId, String staffName) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      final old = _complaints[index];
      _complaints[index] = ComplaintManageModel(
        id: old.id,
        tenantName: old.tenantName,
        roomNo: old.roomNo,
        title: old.title,
        category: old.category,
        priority: old.priority,
        status: 'In Progress',
        assignedStaffName: staffName,
        assignedStaffPhone: '+91 98765 22334',
        createdAt: old.createdAt,
        description: old.description,
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> resolveComplaint(int complaintId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      final old = _complaints[index];
      _complaints[index] = ComplaintManageModel(
        id: old.id,
        tenantName: old.tenantName,
        roomNo: old.roomNo,
        title: old.title,
        category: old.category,
        priority: old.priority,
        status: 'Resolved',
        assignedStaffName: old.assignedStaffName,
        assignedStaffPhone: old.assignedStaffPhone,
        createdAt: old.createdAt,
        description: old.description,
      );
      return true;
    }
    return false;
  }
}
