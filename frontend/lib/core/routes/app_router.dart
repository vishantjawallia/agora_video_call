import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/call/presentation/pages/call_page.dart';
import 'package:frontend/features/home/presentation/pages/home_page.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String call = '/call';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case call:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CallPage(
            channelName: args['channelName'] as String,
            token: args['token'] as String,
            isIncoming: args['isIncoming'] as bool,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
