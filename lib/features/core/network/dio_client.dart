import 'package:dio/dio.dart';
import 'package:caps_book/features/core/network/api_constant.dart';
import 'package:caps_book/features/core/network/hive_service.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await HiveService().getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await HiveService().getRefreshToken();
            if (refreshToken != null) {
              try {
                final refreshResponse = await _dio.post(
                  ApiConstants.refreshToken, // e.g. "/access/refresh/"
                  data: {"refresh": refreshToken},
                );

                final newAccessToken = refreshResponse.data['access'];
                await HiveService().saveToken(newAccessToken);

                // Retry the original request with the new token
                final RequestOptions requestOptions = e.requestOptions;
                requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                final newResponse = await _dio.fetch(requestOptions);
                return handler.resolve(newResponse);
              } catch (refreshError) {
                // Refresh also failed — clear data & maybe logout
                await HiveService().deleteToken();
                return handler.reject(refreshError as DioError);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );

  static Dio get client => _dio;
}
