// customer_service.dart

import 'dart:convert';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/model/customer_details.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  static const String _url = 'https://cabs.zenvicsoft.com/driver/driver/retrieve/';

  static Future<UserModel> fetchDriverDetails() async {
    final token = await HiveService().getToken();

    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load driver profile');
    }
  }
}
