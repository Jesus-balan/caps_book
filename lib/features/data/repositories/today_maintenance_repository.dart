import 'dart:convert';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/model/today_maintenance_model.dart';
import 'package:http/http.dart' as http;

class MaintenanceRepository {
  final String baseUrl =
      "https://h5r5msdk-1111.inc1.devtunnels.ms";

  Future<MaintenanceResponse> fetchMaintenanceList() async {
    final url = Uri.parse("$baseUrl/driver/today-maintenance/");
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
        return MaintenanceResponse.fromJson(jsonData);
      } else {
        throw Exception("Failed to load maintenance data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching maintenance data: $e");
    }
  }
}
