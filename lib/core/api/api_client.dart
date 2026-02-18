import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Platform-aware base URL:
  // - Web (Chrome): use local server to avoid CORS issues in dev
  // - Android Emulator: use 10.0.2.2 (host machine)
  // - Production / Android device: use Render URL
  static String get baseUrl {
    if (kIsWeb) {
      // Flutter web runs in Chrome, use local Django server
      return 'http://localhost:8000/api';
    }
    // Android / iOS / Desktop → production
    return 'https://monely-api.onrender.com/api';
  }

  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Handle token refresh logic here if needed
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get client => _dio;
}
