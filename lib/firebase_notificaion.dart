import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_push_notification/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) {
        showNotification(message, context);
        showLocalNotification(message);
      }
    });
  }

  void showNotification(RemoteMessage message, BuildContext context) async {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializedSettings =
        InitializationSettings(android: android, iOS: null, macOS: null);
    await localNotifications.initialize(
      initializedSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null) {
          final data = Map<String, dynamic>.from(jsonDecode(payload));
          final remoteMessage = RemoteMessage(data: data);
          handleMessage(remoteMessage, context);
        }
      },
    );
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    var channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );
    var androidDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: "@mipmap/ic_launcher",
    );
    var notificationDetails = NotificationDetails(android: androidDetails);
    final payload = message.data.toString();
    await localNotifications.show(
      0,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> setUpInteractiveMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage, context);
    }
    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message, context);
    });
  }

  //redirect to notification screen
  void handleMessage(RemoteMessage message, BuildContext context) {
    if (message.data.containsKey('type') && message.data['type'] == 'home') {
      print('🚀 Redirecting to home screen...');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    } else {
      print(
          "⚠️ Notification does not contain expected 'type' key.${message.data.containsKey('type')} ${message.data['type']}");
    }
  }

  Future<String?> getFCMToken() async {
    String? token = await messaging.getToken();

    if (kDebugMode) {
      print(token);
    }

    //listen for token refresh
    messaging.onTokenRefresh.listen((newToken) async {
      newToken.toString();
      if (kDebugMode) {
        print('new token: $newToken');
      }
    });
  }
}
