import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class AttendanceRepository {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> sendCheckInOut({
    required double latitude,
    required double longitude,
    required bool isCheckIn,
    required String token,
  }) async {
    try {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final String formattedTime = DateFormat('h:mma').format(DateTime.now()); // eg: 4:50PM

      Map<String, dynamic> requestBody = {
        "latitude": latitude,
        "longitude": longitude,
        "check_date": formattedDate,
        if (isCheckIn) "check_in": formattedTime else "check_out": formattedTime,
      };

      final response = await _dio.post(
        "https://39jjhf8l-1000.inc1.devtunnels.ms/driver/check/in/out/",
        data: requestBody,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      return response.data;
    } catch (e) {
      print("Check-in/out error: $e");
      rethrow;
    }
  }
}
