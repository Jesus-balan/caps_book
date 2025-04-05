import 'package:caps_book/features/data/model/booking_model.dart';


class BookingRepository {
  Future<List<Booking>> fetchBookings() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Booking(source: "Kalakkad", destination: "Tirunelveli", distance: "45 km", isCompleted: false),
      Booking(source: "Tenkasi", destination: "Madurai", distance: "70 km", isCompleted: true),
    ];
  }
}
