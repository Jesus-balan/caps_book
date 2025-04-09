import 'package:hive/hive.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  static const String _authBox = 'authBox';
  static const String _tokenKey = 'token';

  // Open box only once
  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(_authBox)) {
      return Hive.box(_authBox);
    } else {
      return await Hive.openBox(_authBox);
    }
  }

  /// Save token
 Future<void> saveToken(String token) async {
  final box = await _getBox();
  await box.put(_tokenKey, token);
}

  /// Get token
  Future<String?> getToken() async {
  final box = await _getBox();
  final token = box.get(_tokenKey);
  print('🐝 Token from Hive: $token');
  return token;
}


  /// Delete token
  Future<void> deleteToken() async {
    final box = await _getBox();
    await box.delete(_tokenKey);
  }

  /// Check if token exists
  Future<bool> isLoggedIn() async {
    final box = await _getBox();
    return box.containsKey(_tokenKey);
  }

  /// Clear all auth data (useful on logout)
  Future<void> clearAuthData() async {
    final box = await _getBox();
    await box.clear();
  }
}
