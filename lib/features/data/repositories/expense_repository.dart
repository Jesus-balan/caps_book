import 'dart:convert';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:http/http.dart' as http;
import 'package:caps_book/features/data/model/expense_model.dart';

class ExpenseService {
  static const String _url = 'https://cabs.zenvicsoft.com/driver/ledger/list/';

  static Future<ExpenseResponse> fetchExpenses() async {
    final token = await HiveService().getToken();

    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ExpenseResponse.fromJson(jsonData);
    } else {
      throw Exception("Failed to load expenses");
    }
  }
}
