class TodayMaintenanceResponse {
  final TodayMaintenanceData data;
  final String status;
  final String actionCode;

  TodayMaintenanceResponse({
    required this.data,
    required this.status,
    required this.actionCode,
  });

  factory TodayMaintenanceResponse.fromJson(Map<String, dynamic> json) {
    return TodayMaintenanceResponse(
      data: TodayMaintenanceData.fromJson(json['data']),
      status: json['status'],
      actionCode: json['action_code'],
    );
  }
}

class TodayMaintenanceData {
  final int count;
  final dynamic next;
  final dynamic previous;
  final List<TodayMaintenanceResult> results;

  TodayMaintenanceData({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory TodayMaintenanceData.fromJson(Map<String, dynamic> json) {
    return TodayMaintenanceData(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results:
          (json['results'] as List)
              .map((e) => TodayMaintenanceResult.fromJson(e))
              .toList(),
    );
  }
}

class TodayMaintenanceResult {
  final int id;
  final String uuid;
  final String? maintenanceId;
  final TodayWorkshopDetails? workshopDetails;
  final TodayVehicleDetails vehicleDetails;
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

  TodayMaintenanceResult({
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

  factory TodayMaintenanceResult.fromJson(Map<String, dynamic> json) {
    return TodayMaintenanceResult(
      id: json['id'],
      uuid: json['uuid'],
      maintenanceId: json['maintenance_id'],
      workshopDetails:
          json['workshop_details'] != null
              ? TodayWorkshopDetails.fromJson(json['workshop_details'])
              : null,
      vehicleDetails: TodayVehicleDetails.fromJson(json['vehicle_details']),
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

class TodayWorkshopDetails {
  final int id;
  final String uuid;
  final String identity;
  final String phone;

  TodayWorkshopDetails({
    required this.id,
    required this.uuid,
    required this.identity,
    required this.phone,
  });

  factory TodayWorkshopDetails.fromJson(Map<String, dynamic> json) {
    return TodayWorkshopDetails(
      id: json['id'],
      uuid: json['uuid'],
      identity: json['identity'],
      phone: json['phone'],
    );
  }
}

class TodayVehicleDetails {
  final int id;
  final String uuid;
  final String identity;

  TodayVehicleDetails({
    required this.id,
    required this.uuid,
    required this.identity,
  });

  factory TodayVehicleDetails.fromJson(Map<String, dynamic> json) {
    return TodayVehicleDetails(
      id: json['id'],
      uuid: json['uuid'],
      identity: json['identity'],
    );
  }
}
