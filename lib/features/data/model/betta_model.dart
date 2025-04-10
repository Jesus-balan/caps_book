class BettaResponse {
  final String status;
  final String actionCode;
  final BettaData data;

  BettaResponse({
    required this.status,
    required this.actionCode,
    required this.data,
  });

  factory BettaResponse.fromJson(Map<String, dynamic> json) {
    return BettaResponse(
      status: json['status'],
      actionCode: json['action_code'],
      data: BettaData.fromJson(json['data']),
    );
  }
}

class BettaData {
  final int count;
  final List<BettaItem> results;

  BettaData({
    required this.count,
    required this.results,
  });

  factory BettaData.fromJson(Map<String, dynamic> json) {
    return BettaData(
      count: json['count'],
      results: List<BettaItem>.from(
        json['results'].map((item) => BettaItem.fromJson(item)),
      ),
    );
  }
}

class BettaItem {
  final int id;
  final String uuid;
  final DriverDetails driverDetails;
  final String bettaType;
  final BookingDetails? bookingDetails;
  final MaintenanceDetails? maintenanceDetails;
  final String amount;

  BettaItem({
    required this.id,
    required this.uuid,
    required this.driverDetails,
    required this.bettaType,
    this.bookingDetails,
    this.maintenanceDetails,
    required this.amount,
  });

  factory BettaItem.fromJson(Map<String, dynamic> json) {
    return BettaItem(
      id: json['id'],
      uuid: json['uuid'],
      driverDetails: DriverDetails.fromJson(json['driver_details']),
      bettaType: json['betta_type'],
      bookingDetails: json['booking_details'] != null
          ? BookingDetails.fromJson(json['booking_details'])
          : null,
      maintenanceDetails: json['maintenance_details'] != null
          ? MaintenanceDetails.fromJson(json['maintenance_details'])
          : null,
      amount: json['amount'],
    );
  }
}

class DriverDetails {
  final int id;
  final String uuid;
  final String identity;

  DriverDetails({
    required this.id,
    required this.uuid,
    required this.identity,
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json) {
    return DriverDetails(
      id: json['id'],
      uuid: json['uuid'],
      identity: json['identity'],
    );
  }
}

class BookingDetails {
  final int id;
  final String uuid;
  final String startPlace;
  final String? endPlace;

  BookingDetails({
    required this.id,
    required this.uuid,
    required this.startPlace,
    this.endPlace,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      id: json['id'],
      uuid: json['uuid'],
      startPlace: json['start_place'],
      endPlace: json['end_place'],
    );
  }
}

class MaintenanceDetails {
  // Update this later if maintenance data is present
  MaintenanceDetails();

  factory MaintenanceDetails.fromJson(Map<String, dynamic> json) {
    return MaintenanceDetails();
  }
}
