import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:goexperts/core/services/api_client.dart';

import 'data/notification_modal.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission();

    print('Permission: ${settings.authorizationStatus}');

    String? fcmtoken = await _messaging.getToken();

    print('FCM Token: $fcmtoken');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    });
  }

  static Future<dynamic> getFcm() async {
    await _messaging.requestPermission();
    String? fcmtoken = await _messaging.getToken();
    return fcmtoken;
  }

  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
    bool? isRead,
  }) async {
    final response = await ApiClient.dio.get(
      "/notifications/user",
      queryParameters: {
        "page": page,
        "limit": limit,
        if (isRead != null) "isRead": isRead,
      },
    );

    final List data = response.data['data'];

    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }
}
