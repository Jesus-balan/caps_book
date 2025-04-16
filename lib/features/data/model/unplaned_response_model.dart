class MaintenanceCreateResponse {
  final MaintenanceData data;
  final String status;
  final String actionCode;

  MaintenanceCreateResponse({
    required this.data,
    required this.status,
    required this.actionCode,
  });

  factory MaintenanceCreateResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceCreateResponse(
      data: MaintenanceData.fromJson(json['data']),
      status: json['status'],
      actionCode: json['action_code'],
    );
  }
}

class MaintenanceData {
  final String? maintenanceType;
  final String? description;
  final String? startDate;
  final String? endDate;
  final double? startKm;
  final double? endKm;
  final String? maintenanceStatus;
  final String? paymentStatus;
  final String? maintenancebillImage;

  MaintenanceData({
    this.maintenanceType,
    this.description,
    this.startDate,
    this.endDate,
    this.startKm,
    this.endKm,
    this.maintenanceStatus,
    this.paymentStatus,
    this.maintenancebillImage,
  });

  factory MaintenanceData.fromJson(Map<String, dynamic> json) {
    return MaintenanceData(
      maintenanceType: json['maintenance_type'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      startKm: json['start_km']?.toDouble(),
      endKm: json['end_km'] != null ? double.tryParse(json['end_km'].toString()) : null,
      maintenanceStatus: json['maintenance_status'],
      paymentStatus: json['payment_status'],
      maintenancebillImage: json['maintenancebill_image'],
    );
  }
}

