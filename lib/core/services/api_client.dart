import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goexperts/splash_screen.dart';
import 'sessionservice.dart';

class ApiClient {
    static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: "https://goexperts-hrms-coun.onrender.com/",
            connectTimeout: const Duration(seconds: 30), // ⬅ increased
            receiveTimeout: const Duration(seconds: 30),
            headers: {"Content-Type": "application/json"},
          ),
        )
        ..interceptors.addAll([
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              // Logging removed for production.

              // ❌ Skip token check for login
              if (!options.path.contains("login")) {
                bool isExpired = await SessionService.isTokenExpired();

                if (isExpired) {
                  await SessionService.clearSession();
                  ApiClient.navigatorKey.currentState?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => SplashScreen()),
                    (route) => false,
                  );

                  return handler.reject(
                    DioException(
                      requestOptions: options,
                      error: "SESSION_EXPIRED",
                    ),
                  );
                }

                String? token = await SessionService.getToken();
                if (token != null) {
                  options.headers["Authorization"] = "Bearer $token";
                }
              }

              return handler.next(options);
            },

            onResponse: (response, handler) {
              return handler.next(response);
            },

            onError: (e, handler) async {
              if (e.response?.statusCode == 401) {
                await SessionService.clearSession();
              }
              return handler.next(e);
            },
          ),

          // 🔍 LOGGING (VERY IMPORTANT)
          LogInterceptor(requestBody: true, responseBody: true, error: true),
        ]);
}
