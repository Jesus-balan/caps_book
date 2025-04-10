import 'dart:convert';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:http/http.dart' as http;
import 'package:caps_book/features/data/model/betta_model.dart';

class BettaService {
  static const String _url = 'https://h5r5msdk-1111.inc1.devtunnels.ms/driver/betta/list/';

  static Future<List<BettaItem>> fetchBettaList() async {
    final token = await HiveService().getToken(); // Assuming your token is stored here

    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final bettaResponse = BettaResponse.fromJson(jsonData);
      return bettaResponse.data.results;
    } else {
      throw Exception('Failed to load betta list');
    }
  }
}
