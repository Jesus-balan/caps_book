// ignore_for_file: public_member_api_docs, sort_constructors_first
class RideBookingModel {
  final String customerName;
  final String vehicleName;
  final String vehicleNumber;
  final DateTime dateTime;
  final String pickupAddress;
  final String dropAddress;
  final String bookingType;

  RideBookingModel({
    required this.customerName,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.dateTime,
    required this.pickupAddress,
    required this.dropAddress,
    required this.bookingType,
  });
}
