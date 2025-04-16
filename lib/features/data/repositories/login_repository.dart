import 'package:caps_book/features/core/network/api_constant.dart';
import 'package:caps_book/features/core/network/dio_client.dart';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/model/login_model.dart';


class LoginRepository {
  final hiveService = HiveService();

  Future<String> login(LoginModel loginModel) async {
    try {
      final response = await DioClient.client.post(
        ApiConstants.login, // this should be "access/login/"
        data: loginModel.toJson(),
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final accessToken = data['access']; // Save this
        await hiveService.saveToken(accessToken);
        return data['message']; // return "Login successful."
      } else {
        throw Exception("Login failed with status code.");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}
