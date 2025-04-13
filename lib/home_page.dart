import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_notificaion.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationService notificationService = NotificationService();

  Future<void> getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    notificationService.requestNotificationPermission();
    notificationService.getFCMToken();

    notificationService.firebaseInit(context);
    notificationService.setUpInteractiveMessage(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    getFCMToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Flutter Firebase Push Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Welcome to Flutter Firebase Push Notification',
            ),
          ],
        ),
      ),
    );
  }
}
