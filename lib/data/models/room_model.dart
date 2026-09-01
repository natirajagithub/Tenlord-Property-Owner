class BedModel {
  final int id;
  final String bedNo;
  final String status; // Occupied, Vacant, Maintenance
  final String? tenantName;
  final String? tenantPhone;

  BedModel({
    required this.id,
    required this.bedNo,
    required this.status,
    this.tenantName,
    this.tenantPhone,
  });

  factory BedModel.fromJson(Map<String, dynamic> json) {
    return BedModel(
      id: json['id'] as int? ?? 1,
      bedNo: json['bed_no'] as String? ?? 'Bed A',
      status: json['status'] as String? ?? 'Occupied',
      tenantName: json['tenant_name'] as String?,
      tenantPhone: json['tenant_phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bed_no': bedNo,
      'status': status,
      'tenant_name': tenantName,
      'tenant_phone': tenantPhone,
    };
  }
}

class RoomModel {
  final int id;
  final int floorNo;
  final String roomNo;
  final String roomType; // Single, 2-Sharing, 3-Sharing
  final bool isAc;
  final num monthlyRent;
  final List<BedModel> beds;

  RoomModel({
    required this.id,
    required this.floorNo,
    required this.roomNo,
    required this.roomType,
    required this.isAc,
    required this.monthlyRent,
    required this.beds,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as int? ?? 1,
      floorNo: json['floor_no'] as int? ?? 1,
      roomNo: json['room_no'] as String? ?? '101',
      roomType: json['room_type'] as String? ?? '2-Sharing',
      isAc: json['is_ac'] as bool? ?? true,
      monthlyRent: json['monthly_rent'] as num? ?? 8500,
      beds: (json['beds'] as List<dynamic>?)
              ?.map((e) => BedModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'floor_no': floorNo,
      'room_no': roomNo,
      'room_type': roomType,
      'is_ac': isAc,
      'monthly_rent': monthlyRent,
      'beds': beds.map((e) => e.toJson()).toList(),
    };
  }
}
