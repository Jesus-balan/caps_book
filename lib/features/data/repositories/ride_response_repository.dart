import 'dart:convert';
import 'package:caps_book/features/data/model/rideBooking_model.dart';
import 'package:http/http.dart' as http;
import 'package:caps_book/features/core/network/hive_service.dart';

class RideBookingRepository {
  final String _baseUrl = 'https://cabs.zenvicsoft.com/driver/booking/ordered/';

  Future<List<RideBookingModel>> fetchOrderedBookings() async {
    final token = await HiveService().getToken(); // 🔐 get token from Hive

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final results = decoded['data']['results'] as List<dynamic>;

      return results.map((json) => RideBookingModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch ride bookings.');
    }
  }

 Future<RideBookingModel?> fetchFirstUpcomingBooking() async {
  final token = await HiveService().getToken();
  final url = Uri.parse('https://cabs.zenvicsoft.com/driver/booking/ordered/');

  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);

    // Safely extract results list
    final List<dynamic> jsonList = json['data']?['results'] ?? [];

    // Filter only 'Upcoming' bookings
    final upcoming = jsonList
        .map((json) => RideBookingModel.fromJson(json))
        .where((booking) => booking.booking_status == 'Ordered')
        .toList();

    return upcoming.isNotEmpty ? upcoming.first : null;
  } else {
    throw Exception('Failed to load bookings');
  }
}
}
