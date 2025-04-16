class VehicleFilterResponse {
  final FilterData filterData;

  VehicleFilterResponse({required this.filterData});

  factory VehicleFilterResponse.fromJson(Map<String, dynamic> json) {
    return VehicleFilterResponse(
      filterData: FilterData.fromJson(json['data']['filter_data']),
    );
  }
}

class FilterData {
  final List<VehicleType> vehicleTypes;
  final List<Vehicle> vehicles;
  final List<Workshop> workshops;

  FilterData({
    required this.vehicleTypes,
    required this.vehicles,
    required this.workshops,
  });

  factory FilterData.fromJson(Map<String, dynamic> json) {
    return FilterData(
      vehicleTypes: (json['vehicle_type'] as List)
          .map((e) => VehicleType.fromJson(e))
          .toList(),
      vehicles: (json['vehicle'] as List)
          .map((e) => Vehicle.fromJson(e))
          .toList(),
      workshops: (json['workshop'] as List)
          .map((e) => Workshop.fromJson(e))
          .toList(),
    );
  }
}

class VehicleType {
  final String id;
  final String uuid;
  final String identity;

  VehicleType({
    required this.id,
    required this.uuid,
    required this.identity,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json['id'],
      uuid: json['uuid'],
      identity: json['identity'],
    );
  }
}

class Vehicle {
  final int id;
  final String uuid;
  final String identity;
  final String vehicleType;

  Vehicle({
    required this.id,
    required this.uuid,
    required this.identity,
    required this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      uuid: json['uuid'],
      identity: json['identity'],
      vehicleType: json['vehicle_type'],
    );
  }
}

class Workshop {
  final int id;
  final String uuid;
  final String? name;

  Workshop({
    required this.id,
    required this.uuid,
    this.name,
  });

  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'] ?? '', 
    );
  }
}
