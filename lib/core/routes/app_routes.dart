import 'package:flutter/material.dart';

import '../../pages/landing_page.dart';
import '../../pages/login_page.dart';
import '../../pages/registration_page.dart';
import '../../pages/dashboard_page.dart';
import '../../pages/screening_progress_page.dart';
import '../../pages/new_screening_page.dart';
import '../../pages/screening_result_page.dart';
import '../../pages/my_screenings_page.dart';

import '../../pages/admin/admin_login_page.dart';
import '../../pages/admin/admin_registration_page.dart';

class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String pricing = '/pricing';
  static const String screening = '/screening';
  static const String dashboard = '/dashboard';
  static const String screeningProgress = '/screening-progress';
  static const String newScreening = '/new-screening';
  static const String screeningResult = '/screening-result';
  static const String myScreenings = '/my-screenings';

  static const String adminLogin = '/admin-login';
  static const String adminRegistration = '/admin-registration';

  static Map<String, WidgetBuilder> get routes {
    return {
      landing: (context) => const LandingPage(),
      login: (context) => const LoginPage(),
      registration: (context) => const RegistrationPage(),
      pricing: (context) => const LandingPage(),
      screening: (context) => const LandingPage(),
      dashboard: (context) => const DashboardPage(),
      screeningProgress: (context) => const ScreeningProgressPage(),
      newScreening: (context) => const NewScreeningPage(),
      screeningResult: (context) => const ScreeningResultPage(),
      myScreenings: (context) => const MyScreeningsPage(),
      adminLogin: (context) => const AdminLoginPage(),
      adminRegistration: (context) => const AdminRegistrationPage(),
    };
  }
}