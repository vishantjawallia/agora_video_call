
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:frontend/core/routes/app_router.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for notifications
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle incoming messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.data['type'] == 'call') {
      await _showIncomingCallNotification(
        callId: message.data['callId'],
        callerName: message.data['callerName'],
        channelName: message.data['channelName'],
        token: message.data['token'],
      );
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (message.data['type'] == 'call') {
      _showIncomingCallNotification(
        callId: message.data['callId'],
        callerName: message.data['callerName'],
        channelName: message.data['channelName'],
        token: message.data['token'],
      );
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    if (message.data['type'] == 'call') {
      // Navigate to call screen
      navigatorKey.currentState?.pushNamed(
        AppRouter.call,
        arguments: {
          'channelName': message.data['channelName'],
          'token': message.data['token'],
          'isIncoming': true,
        },
      );
    }
  }

  Future<void> _showIncomingCallNotification({
    required String callId,
    required String callerName,
    required String channelName,
    required String token,
  }) async {
    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'Toride',
      avatar: 'https://i.pravatar.cc/100',
      handle: callerName,
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      
      // android: AndroidParams(

      // //   showNotification: true,
      // ),
      // missedCallNotification: const NotificationParams(
      //   showNotification: true,
      //   isShowCallback: true,
      //   subtitle: 'Missed call',
      //   callbackText: 'Call back',
      // ),
      extra: <String, dynamic>{
        'channelName': channelName,
        'token': token,
      },
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
}

// Global navigator key for handling navigation from background
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
