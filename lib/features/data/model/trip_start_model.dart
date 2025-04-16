class BookingResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Booking> results;
  final String status;
  final String actionCode;

  BookingResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    required this.status,
    required this.actionCode,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return BookingResponse(
      count: data['count'],
      next: data['next'],
      previous: data['previous'],
      results: (data['results'] as List)
          .map((e) => Booking.fromJson(e))
          .toList(),
      status: json['status'],
      actionCode: json['action_code'],
    );
  }
}

class Booking {
  final int id;
  final String uuid;
  final CustomerDetails customerDetails;
  final dynamic sponsorDetails;
  final VehicleDetails vehicleDetails;
  final String startDate;
  final String endDate;
  final String? tripStartDate;
  final String? tripEndDate;
  final String? customerPickupTime;
  final String? customerDropTime;
  final String startPlace;
  final String endPlace;
  final dynamic startKm;
  final String rentType;
  final dynamic fuel;
  final String remarks;
  final bool isSponsored;
  final String bookingStatus;

  Booking({
    required this.id,
    required this.uuid,
    required this.customerDetails,
    this.sponsorDetails,
    required this.vehicleDetails,
    required this.startDate,
    required this.endDate,
    this.tripStartDate,
    this.tripEndDate,
    this.customerPickupTime,
    this.customerDropTime,
    required this.startPlace,
    required this.endPlace,
    this.startKm,
    required this.rentType,
    this.fuel,
    required this.remarks,
    required this.isSponsored,
    required this.bookingStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      uuid: json['uuid'],
      customerDetails:
          CustomerDetails.fromJson(json['customer_details']),
      sponsorDetails: json['sponsor_details'],
      vehicleDetails: VehicleDetails.fromJson(json['vehicle_details']),
      startDate: json['start_date'],
      endDate: json['end_date'],
      tripStartDate: json['trip_start_date'],
      tripEndDate: json['trip_end_date'],
      customerPickupTime: json['customer_pickup_time'],
      customerDropTime: json['customer_drop_time'],
      startPlace: json['start_place'],
      endPlace: json['end_place'],
      startKm: json['start_km'],
      rentType: json['rent_type'],
      fuel: json['fuel'],
      remarks: json['remarks'],
      isSponsored: json['is_sponsored'],
      bookingStatus: json['booking_status'],
    );
  }
}

class CustomerDetails {
  final int id;
  final String uuid;
  final String identity;
  final UserDetails userDetails;

  CustomerDetails({
    required this.id,
    required this.uuid,
    required this.identity,
    required this.userDetails,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      id: json['id'],
      uuid: json['uuid'],
      identity: json['identity'],
      userDetails: UserDetails.fromJson(json['user_details']),
    );
  }
}

class UserDetails {
  final int id;
  final String uuid;
  final String phoneNumber;

  UserDetails({
    required this.id,
    required this.uuid,
    required this.phoneNumber,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      uuid: json['uuid'],
      phoneNumber: json['phone_number'],
    );
  }
}

class VehicleDetails {
  final int id;
  final String uuid;
  final String identity;
  final String vehicleType;
  final String vehicleNo;

  VehicleDetails({
    required this.id,
    required this.uuid,
    required this.identity,
    required this.vehicleType,
    required this.vehicleNo,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      id: json['id'],
      uuid: json['uuid'],
      identity: json['identity'],
      vehicleType: json['vehicle_type'],
      vehicleNo: json['vehicle_no'],
    );
  }
}
