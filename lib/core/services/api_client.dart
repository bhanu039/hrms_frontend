import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goexperts/core/widgets/top_message.dart';
import 'package:goexperts/splash_screen.dart';
import '../app_constants/app_constants.dart';
import 'sessionservice.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class ApiClient {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: AppConstants.apiBaseUrl,
            connectTimeout: const Duration(seconds: 100), // ⬅ increased
            receiveTimeout: const Duration(seconds: 100),
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

            onError: (DioException e, ErrorInterceptorHandler handler) async {
              if (e.response?.statusCode == 401) {
                await SessionService.clearSession();
              }

              String message;

              switch (e.type) {
                case DioExceptionType.connectionTimeout:
                  message = "No internet connection or server unreachable.";
                  break;

                case DioExceptionType.receiveTimeout:
                  message = "Server response timeout.";
                  break;

                case DioExceptionType.sendTimeout:
                  message = "Request timeout.";
                  break;

                case DioExceptionType.connectionError:
                  message = "Please check your internet connection.";
                  break;

                default:
                  message = e.message ?? "Something went wrong";
              }

              // Show message using navigatorKey context
              final context = ApiClient.navigatorKey.currentContext;
              if (context != null) {
                TopMessage.show(context, message, color: AppColors.errorColor);
              }

              return handler.reject(
                DioException(
                  requestOptions: e.requestOptions,
                  response: e.response,
                  type: e.type,
                  error: message,
                  message: message,
                ),
              );
            },
          ),

          // 🔍 LOGGING (VERY IMPORTANT)
          LogInterceptor(requestBody: true, responseBody: true, error: true),
        ]);
}
