class OwnerDashboardModel {
  final num totalRevenue;
  final num totalCollected;
  final num totalPendingDues;
  final int totalPropertiesCount;
  final int totalRoomsCount;
  final int totalBedsCount;
  final int occupiedBedsCount;
  final int vacantBedsCount;
  final int pendingComplaintsCount;
  final int overdueTenantsCount;

  OwnerDashboardModel({
    required this.totalRevenue,
    required this.totalCollected,
    required this.totalPendingDues,
    required this.totalPropertiesCount,
    required this.totalRoomsCount,
    required this.totalBedsCount,
    required this.occupiedBedsCount,
    required this.vacantBedsCount,
    required this.pendingComplaintsCount,
    required this.overdueTenantsCount,
  });

  factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) {
    return OwnerDashboardModel(
      totalRevenue: json['total_revenue'] as num? ?? 459000,
      totalCollected: json['total_collected'] as num? ?? 425000,
      totalPendingDues: json['total_pending_dues'] as num? ?? 34000,
      totalPropertiesCount: json['total_properties_count'] as int? ?? 2,
      totalRoomsCount: json['total_rooms_count'] as int? ?? 20,
      totalBedsCount: json['total_beds_count'] as int? ?? 50,
      occupiedBedsCount: json['occupied_beds_count'] as int? ?? 46,
      vacantBedsCount: json['vacant_beds_count'] as int? ?? 4,
      pendingComplaintsCount: json['pending_complaints_count'] as int? ?? 2,
      overdueTenantsCount: json['overdue_tenants_count'] as int? ?? 4,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'total_collected': totalCollected,
      'total_pending_dues': totalPendingDues,
      'total_properties_count': totalPropertiesCount,
      'total_rooms_count': totalRoomsCount,
      'total_beds_count': totalBedsCount,
      'occupied_beds_count': occupiedBedsCount,
      'vacant_beds_count': vacantBedsCount,
      'pending_complaints_count': pendingComplaintsCount,
      'overdue_tenants_count': overdueTenantsCount,
    };
  }
}
