import 'package:flutter/material.dart';
import 'package:frontend/core/routes/app_router.dart';
import 'package:frontend/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toride',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.initialRoute,
    );
  }
}
