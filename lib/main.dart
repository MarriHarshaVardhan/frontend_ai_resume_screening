import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/user_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load user session from stored preferences
  await UserSession.loadSession();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Resume Screener',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: UserSession.isLoggedIn
          ? AppRoutes.dashboard
          : AppRoutes.landing,
      routes: AppRoutes.routes,
    );
  }
}
