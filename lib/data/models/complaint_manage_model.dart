class ComplaintManageModel {
  final int id;
  final String tenantName;
  final String roomNo;
  final String title;
  final String category;
  final String priority;
  final String status; // Pending, In Progress, Resolved
  final String? assignedStaffName;
  final String? assignedStaffPhone;
  final String createdAt;
  final String description;

  ComplaintManageModel({
    required this.id,
    required this.tenantName,
    required this.roomNo,
    required this.title,
    required this.category,
    required this.priority,
    required this.status,
    this.assignedStaffName,
    this.assignedStaffPhone,
    required this.createdAt,
    required this.description,
  });

  factory ComplaintManageModel.fromJson(Map<String, dynamic> json) {
    return ComplaintManageModel(
      id: json['id'] as int? ?? 1,
      tenantName: json['tenant_name'] as String? ?? 'Tenant',
      roomNo: json['room_no'] as String? ?? '101',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      priority: json['priority'] as String? ?? 'Normal',
      status: json['status'] as String? ?? 'Pending',
      assignedStaffName: json['assigned_staff_name'] as String?,
      assignedStaffPhone: json['assigned_staff_phone'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_name': tenantName,
      'room_no': roomNo,
      'title': title,
      'category': category,
      'priority': priority,
      'status': status,
      'assigned_staff_name': assignedStaffName,
      'assigned_staff_phone': assignedStaffPhone,
      'created_at': createdAt,
      'description': description,
    };
  }
}
