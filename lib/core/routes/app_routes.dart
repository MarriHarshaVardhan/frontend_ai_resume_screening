import 'package:flutter/material.dart';
import '../../pages/landing_page.dart';
import '../../pages/login_page.dart';
import '../../pages/registration_page.dart';

class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String pricing = '/pricing';
  static const String screening = '/screening';

  static Map<String, WidgetBuilder> get routes {
    return {
      landing: (context) => const LandingPage(),
      login: (context) => const LoginPage(),
      registration: (context) => const RegistrationPage(),
      pricing: (context) => const LandingPage(),
      screening: (context) => const LandingPage(),
    };
  }
}
