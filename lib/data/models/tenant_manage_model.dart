class TenantManageModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String propertyName;
  final String roomNo;
  final String bedNo;
  final num monthlyRent;
  final num depositPaid;
  final String joinDate;
  final String rentDueDate;
  final String paymentStatus; // Paid, Due, Overdue
  final String guardianName;
  final String guardianPhone;

  TenantManageModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.propertyName,
    required this.roomNo,
    required this.bedNo,
    required this.monthlyRent,
    required this.depositPaid,
    required this.joinDate,
    required this.rentDueDate,
    required this.paymentStatus,
    required this.guardianName,
    required this.guardianPhone,
  });

  factory TenantManageModel.fromJson(Map<String, dynamic> json) {
    return TenantManageModel(
      id: json['id'] as int? ?? 1,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      propertyName: json['property_name'] as String? ?? 'Skyline Luxury PG',
      roomNo: json['room_no'] as String? ?? '101',
      bedNo: json['bed_no'] as String? ?? 'Bed A',
      monthlyRent: json['monthly_rent'] as num? ?? 8500,
      depositPaid: json['deposit_paid'] as num? ?? 15000,
      joinDate: json['join_date'] as String? ?? '',
      rentDueDate: json['rent_due_date'] as String? ?? '',
      paymentStatus: json['payment_status'] as String? ?? 'Paid',
      guardianName: json['guardian_name'] as String? ?? '',
      guardianPhone: json['guardian_phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'property_name': propertyName,
      'room_no': roomNo,
      'bed_no': bedNo,
      'monthly_rent': monthlyRent,
      'deposit_paid': depositPaid,
      'join_date': joinDate,
      'rent_due_date': rentDueDate,
      'payment_status': paymentStatus,
      'guardian_name': guardianName,
      'guardian_phone': guardianPhone,
    };
  }
}
