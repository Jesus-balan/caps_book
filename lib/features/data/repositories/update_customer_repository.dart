import 'dart:convert';
import 'package:http/http.dart' as http;

class DriverService {
  static Future<bool> updateDriverDetails({
    required String token,
    required String email,
    required String dob,
    required String address,
  }) async {
    final url = Uri.parse("https://h5r5msdk-1111.inc1.devtunnels.ms/driver/driver/update/");

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // replace with your actual token logic
      },
      body: jsonEncode({
        "email": email,
        "dob": dob,
        "address": address,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Update failed: ${response.statusCode} ${response.body}");
      return false;
    }
  }
}
