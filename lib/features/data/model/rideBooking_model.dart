class RideBookingModel {
  final String customerName;
final DateTime dateTime;
final String pickupAddress;
final String dropAddress;
final String bookingType;
final String vehicleName;
final String vehicleNumber;
final String booking_status;
final String customerPhone;
final String startKm;
final String uuid;


  RideBookingModel({
    required this.customerName,
    required this.dateTime,
    required this.pickupAddress,
    required this.dropAddress,
    required this.bookingType,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.booking_status,
    required this.customerPhone,
    required this.startKm,
    required this.uuid,
  });

 factory RideBookingModel.fromJson(Map<String, dynamic> json) {
  return RideBookingModel(
    customerName: json['customer_details']?['identity'] ?? 'Unknown',
    vehicleName: json['vehicle_details']?['identity'] ?? '',
    vehicleNumber: json['vehicle_details']?['vehicle_no'] ?? '', // ✅ Corrected
    dateTime: DateTime.parse(json['start_date']),
    pickupAddress: json['start_place'] ?? '',
    dropAddress: json['end_place'] ?? '',
    bookingType: json['rent_type'] ?? '', // Changed from booking_status
    booking_status: json['booking_status'] ?? '', // Changed from booking_status
    customerPhone: json['booking_status'] ?? '', 
    startKm: json['start_km'] ?? '', 
    uuid: json['uuid'] ?? '', 
  );
}
}
