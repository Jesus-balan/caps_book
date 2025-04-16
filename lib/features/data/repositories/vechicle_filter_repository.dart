import 'dart:convert';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/model/vechicle_filter_model.dart';
import 'package:http/http.dart' as http;


class VehicleFilterService {
  Future<VehicleFilterResponse?> fetchVehicleFilters() async {
    final url = Uri.parse(
      'https://cabs.zenvicsoft.com/driver/meta/vehicles-workshops/',
    );

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
        final Map<String, dynamic> data = jsonDecode(response.body);
        return VehicleFilterResponse.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
