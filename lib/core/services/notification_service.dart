// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../network/dio_client.dart';
import '../storage/token_storage.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message: ${message.messageId}');
}

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final DioClient _dioClient = DioClient();
  static final TokenStorage _tokenStorage = TokenStorage();

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          log('Notification clicked: ${details.payload}');
        },
      );

      await _createNotificationChannel();

      await requestPermissions();

      _setupMessageHandlers();

      await getToken();

      log('NotificationService initialized successfully');
    } catch (e) {
      log('Error initializing NotificationService: $e');
    }
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_notification_channel',
      'Notificaciones BarberTrack',
      description: 'Canal principal para notificaciones de BarberTrack',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log('Permission status: ${settings.authorizationStatus}');
  }

  static Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();

      if (token != null) {
        await _registerTokenInAPI(token);
      }

      return token;
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  static Future<void> registerTokenInAPI() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _registerTokenInAPI(token);
      } else {
        log('No se pudo obtener el token FCM');
      }
    } catch (e) {
      log('Error obteniendo token FCM para registro: $e');
    }
  }

  static Future<void> _registerTokenInAPI(String fcmToken) async {
    try {
      String? authToken = await _tokenStorage.getToken();

      if (authToken == null) {
        log(
          'No hay token de autenticación. No se puede registrar el token FCM.',
        );
        return;
      }

      String deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';

      final response = await _dioClient.dio.post(
        '/users/fcm/token',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        data: {'token': fcmToken, 'deviceId': deviceId, 'platform': 'android'},
      );
      if (response.statusCode == 201) {
      } else {}
    } catch (e) {
      log('Error registrando token FCM en la API: $e');
      if (e is DioException) {
        log('Status Code: ${e.response?.statusCode}');
      }
    }
  }

  static void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('App abierta desde notificación');
      _handleNotificationClick(message);
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log('App abierta desde notificación (estaba cerrada)');
        _handleNotificationClick(message);
      }
    });
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'default_notification_channel',
          'Notificaciones BarberTrack',
          channelDescription:
              'Canal principal para notificaciones de BarberTrack',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'BarberTrack',
      message.notification?.body ?? 'Nueva notificación',
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  static void _handleNotificationClick(RemoteMessage message) {
    log('Handling notification click with data: ${message.data}');
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      log('Subscribed to topic: $topic');
    } catch (e) {
      log('Error subscribing to topic $topic: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      log('Unsubscribed from topic: $topic');
    } catch (e) {
      log('Error unsubscribing from topic $topic: $e');
    }
  }
}
