import 'package:flutter/material.dart';
import 'package:nine_hour_chat_app/config/theme/app_theme.dart';
import 'package:nine_hour_chat_app/data/services/service_locator.dart';
import 'package:nine_hour_chat_app/presentations/screens/auth/login_screen.dart';
import 'package:nine_hour_chat_app/router/app_router.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Application',
      navigatorKey: getIt<AppRouter>().navigatorKey,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
