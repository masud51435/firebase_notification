import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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