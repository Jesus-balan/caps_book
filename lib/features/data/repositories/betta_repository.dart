import 'dart:convert';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:http/http.dart' as http;
import 'package:caps_book/features/data/model/betta_model.dart';

class BettaService {
  static const String _url =
      'https://cabs.zenvicsoft.com/driver/betta/list/';

  static Future<List<BettaItem>> fetchBettaList() async {
    final token =
        await HiveService().getToken(); // Assuming your token is stored here

    final response = await http
        .get(Uri.parse(_url), headers: {'Authorization': 'Bearer $token'})
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final bettaResponse = BettaResponse.fromJson(jsonData);
      return bettaResponse.data.results;
    } else {
      return []; // instead of throwing
    }
  }
}
