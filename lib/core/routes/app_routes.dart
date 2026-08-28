import 'package:flutter/material.dart';
import '../../features/landing/presentation/pages/landing_page.dart';

class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String pricing = '/pricing';
  static const String screening = '/screening';

  static Map<String, WidgetBuilder> get routes {
    return {
      landing: (context) => const LandingPage(),
      // Future screen placeholders
      login: (context) => const LandingPage(), // Replace when Auth module is added
      pricing: (context) => const LandingPage(), // Replace when Pricing module is added
      screening: (context) => const LandingPage(), // Replace when Screening module is added
    };
  }
}
