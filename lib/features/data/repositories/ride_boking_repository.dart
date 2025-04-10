import 'dart:convert';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/model/myride_model.dart';
import 'package:http/http.dart' as http;

class RideRepository {

  

  RideRepository();

Future<List<RideBookingModel>> fetchBookings() async {
  final url = Uri.parse('https://h5r5msdk-1111.inc1.devtunnels.ms/driver/booking/ordered/');
  final token = await HiveService().getToken();
  print('🔐 Token used in API call: $token');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // or try 'Token $token'
    },
  );

  print('📡 Status Code: ${response.statusCode}');
  print('📡 Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final results = data['data']['results'] as List;

    return results.map((item) => RideBookingModel.fromJson(item)).toList();

  } else {
    throw Exception('Failed to load bookings: ${response.statusCode}');
  }
}

}