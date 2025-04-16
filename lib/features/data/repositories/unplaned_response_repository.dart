import 'dart:convert';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/model/unplaned_response_model.dart';
import 'package:http/http.dart' as http;

class MaintenanceService {
  final String baseUrl = 'https://cabs.zenvicsoft.com/'; // Update with your actual base URL

  Future<MaintenanceCreateResponse?> createMaintenance(Map<String, dynamic> requestBody) async {
    try {
    final token = await HiveService().getToken();

      final url = Uri.parse('$baseUrl/driver/maintenance/cud/'); // Adjust endpoint if needed

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return MaintenanceCreateResponse.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
