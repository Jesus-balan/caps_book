import 'package:hive/hive.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  static const String _authBox = 'authBox';
  static const String _tokenKey = 'token';
  static const String _capsBox = 'capsBox'; // For trip-related data

  // Open the auth box
  Future<Box> _getAuthBox() async {
    if (Hive.isBoxOpen(_authBox)) {
      return Hive.box(_authBox);
    } else {
      return await Hive.openBox(_authBox);
    }
  }

  // Open the caps box for trip data
  Future<Box> _getCapsBox() async {
    if (Hive.isBoxOpen(_capsBox)) {
      return Hive.box(_capsBox);
    } else {
      return await Hive.openBox(_capsBox);
    }
  }

  /// Save token
  Future<void> saveToken(String token) async {
    final box = await _getAuthBox();
    await box.put(_tokenKey, token);
  }

  /// Get token
  Future<String?> getToken() async {
    final box = await _getAuthBox();
    final token = box.get(_tokenKey);
    print('🐝 Token from Hive: $token');
    return token;
  }

  /// Delete token
  Future<void> deleteToken() async {
    final box = await _getAuthBox();
    await box.delete(_tokenKey);
  }

  /// Check if token exists
  Future<bool> isLoggedIn() async {
    final box = await _getAuthBox();
    return box.containsKey(_tokenKey);
  }

  /// Clear all auth data (useful on logout)
  Future<void> clearAuthData() async {
    final box = await _getAuthBox();
    await box.clear();
  }

  /// Clear trip times (pickup, drop, complete, return)
  Future<void> clearTripTimes() async {
    final box = await _getCapsBox();
    await box.delete('pickupTime');
    await box.delete('dropTime');
    await box.delete('completeTime');
    await box.delete('returnToCabTime');
  }

  Future<void> saveBoxValue(String key, String value) async {
  final box = await Hive.openBox('capsBox');
  await box.put(key, value);
}


  /// Save trip time data
  Future<void> saveTripTime(String key, String time) async {
    final box = await _getCapsBox();
    await box.put(key, time);
  }

  /// Get trip time data
  Future<String?> getTripTime(String key) async {
    final box = await _getCapsBox();
    return box.get(key);
  }

  Future<void> saveRefreshToken(String token) async {
  final box = await Hive.openBox('auth');
  await box.put('refreshToken', token);
}

Future<String?> getRefreshToken() async {
  final box = await Hive.openBox('auth');
  return box.get('refreshToken');
}

}
