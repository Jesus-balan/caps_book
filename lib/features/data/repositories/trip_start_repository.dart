import 'dart:convert';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/model/trip_start_model.dart';
import 'package:http/http.dart' as http;

class BookingRepository {
  final String apiUrl = 'https://cabs.zenvicsoft.com/driver/booking/trip-started/';

  Future<BookingResponse> fetchBookingList() async {
    try {
      final token = await HiveService().getToken();

      if (token == null) {
        throw Exception("Access token not found.");
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody['data'] == null) {
          throw Exception("Unexpected response: 'data' field missing.");
        }

        return BookingResponse.fromJson(jsonBody);
      } else {
        throw Exception('Failed to load booking data. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching booking list: $e');
    }
  }
}
