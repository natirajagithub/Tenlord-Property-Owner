class PropertyModel {
  final int id;
  final String name;
  final String address;
  final String city;
  final int totalFloors;
  final int totalRooms;
  final int totalBeds;
  final int occupiedBeds;
  final String wardenName;
  final String wardenPhone;

  PropertyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.totalFloors,
    required this.totalRooms,
    required this.totalBeds,
    required this.occupiedBeds,
    required this.wardenName,
    required this.wardenPhone,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as int? ?? 1,
      name: json['name'] as String? ?? 'Skyline Luxury PG',
      address: json['address'] as String? ?? 'Koramangala 4th Block',
      city: json['city'] as String? ?? 'Bengaluru',
      totalFloors: json['total_floors'] as int? ?? 4,
      totalRooms: json['total_rooms'] as int? ?? 20,
      totalBeds: json['total_beds'] as int? ?? 50,
      occupiedBeds: json['occupied_beds'] as int? ?? 46,
      wardenName: json['warden_name'] as String? ?? 'Suresh Kumar',
      wardenPhone: json['warden_phone'] as String? ?? '+91 98765 00123',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'total_floors': totalFloors,
      'total_rooms': totalRooms,
      'total_beds': totalBeds,
      'occupied_beds': occupiedBeds,
      'warden_name': wardenName,
      'warden_phone': wardenPhone,
    };
  }
}
