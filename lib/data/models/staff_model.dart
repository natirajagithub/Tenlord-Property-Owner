class StaffModel {
  final int id;
  final String name;
  final String role; // Electrician, Plumber, Housekeeping, Warden, Cook
  final String phone;
  final String status;

  StaffModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    this.status = 'Available',
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] as int? ?? 1,
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'Warden',
      phone: json['phone'] as String? ?? '',
      status: json['status'] as String? ?? 'Available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'phone': phone,
      'status': status,
    };
  }
}
