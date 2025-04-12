import 'dart:convert';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/model/maintenance_response_model.dart';
import 'package:http/http.dart' as http;

class UnplannedMaintenanceRepository {
  final String baseUrl = "https://h5r5msdk-1111.inc1.devtunnels.ms";

  Future<TodayMaintenanceResponse> fetchUnplannedMaintenanceList() async {
    final url = Uri.parse("$baseUrl/driver/today-Unplanned/");
    final token = await HiveService().getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return TodayMaintenanceResponse.fromJson(jsonData);
      } else {
        throw Exception("Failed to load unplanned maintenance: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching unplanned maintenance: $e");
    }
  }
}
