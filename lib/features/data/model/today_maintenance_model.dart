class MaintenanceResponse {
  final MaintenanceData data;
  final String status;
  final String actionCode;

  MaintenanceResponse({
    required this.data,
    required this.status,
    required this.actionCode,
  });

 factory MaintenanceResponse.fromJson(Map<String, dynamic> json) {
  return MaintenanceResponse(
    data: json['data'] != null
        ? MaintenanceData.fromJson(json['data'])
        : MaintenanceData(count: 0, next: null, previous: null, results: []),
    status: json['status'] ?? '',
    actionCode: json['action_code'] ?? '',
  );
}

}

class MaintenanceData {
  final int count;
  final dynamic next;
  final dynamic previous;
  final List<MaintenanceResult> results;

  MaintenanceData({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory MaintenanceData.fromJson(Map<String, dynamic> json) {
    return MaintenanceData(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((e) => MaintenanceResult.fromJson(e))
          .toList(),
    );
  }

  String? get startDate => null;
}

class MaintenanceResult {
  final int id;
  final String uuid;
  final String? maintenanceId;
  final WorkshopDetails? workshopDetails;
  final VehicleDetails vehicleDetails;
  final int driver;
  final String? maintenanceType;
  final String? description;
  final String? startDate;
  final String? startKm;
  final String? endKm;
  final String? endDate;
  final String? cost;
  final String? maintenanceStatus;
  final String? paymentStatus;
  final dynamic maintenancebillImageDetails;

  MaintenanceResult({
    required this.id,
    required this.uuid,
    required this.maintenanceId,
    required this.workshopDetails,
    required this.vehicleDetails,
    required this.driver,
    required this.maintenanceType,
    required this.description,
    required this.startDate,
    required this.startKm,
    this.endKm,
    this.endDate,
    this.cost,
    required this.maintenanceStatus,
    required this.paymentStatus,
    this.maintenancebillImageDetails,
  });

  factory MaintenanceResult.fromJson(Map<String, dynamic> json) {
    return MaintenanceResult(
      id: json['id'],
      uuid: json['uuid'],
      maintenanceId: json['maintenance_id'],
      workshopDetails: json['workshop_details'] != null
          ? WorkshopDetails.fromJson(json['workshop_details'])
          : null,
      vehicleDetails: VehicleDetails.fromJson(json['vehicle_details']),
      driver: json['driver'],
      maintenanceType: json['maintenance_type'],
      description: json['description'],
      startDate: json['start_date'],
      startKm: json['start_km'],
      endKm: json['end_km'],
      endDate: json['end_date'],
      cost: json['cost'],
      maintenanceStatus: json['maintenance_status'],
      paymentStatus: json['payment_status'],
      maintenancebillImageDetails: json['maintenancebill_image_details'],
    );
  }
}


class WorkshopDetails {
  final int id;
  final String uuid;
  final String identity;
  final String phone;

  WorkshopDetails({
    required this.id,
    required this.uuid,
    required this.identity,
    required this.phone,
  });

  factory WorkshopDetails.fromJson(Map<String, dynamic> json) {
    return WorkshopDetails(
      id: json['id'],
      uuid: json['uuid'],
      identity: json['identity'],
      phone: json['phone'],
    );
  }
}

class VehicleDetails {
  final int id;
  final String uuid;
  final String identity;

  VehicleDetails({
    required this.id,
    required this.uuid,
    required this.identity,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      id: json['id'],
      uuid: json['uuid'],
      identity: json['identity'],
    );
  }
}
