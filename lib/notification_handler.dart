import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationHandler() {
    initFirebaseMessaging();
  }

  // Ensure this method is defined in your NotificationHandler class
  Future<void> initFirebaseMessaging() async {
    // Request permission for iOS and handle incoming FCM messages
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Ensure you have this icon in your Android drawable resources
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  void _handleMessage(RemoteMessage message) {
    // Assuming that all notifications include a title and body in their payload
    RemoteNotification? notification = message.notification;
    if (notification != null && notification.android != null) {
      _showNotification(notification.title, notification.body);
    }
  }

  Future<void> _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel Name
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title ?? 'No Title', // Notification Title
      body ?? 'No Body', // Notification Body
      platformChannelSpecifics,
    );
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification tap
    print('Notification clicked with payload: ${response.payload}');
  }
}
