class AppConstants {
  // ================= APP CONFIG =================

  static const String appName = 'AI Resume Screener';

  static const String copyrightText =
      '© 2026 AI Resume Screener';

  static const String contactEmail =
      'hello@airesumescreener.app';

  // ================= API CONFIG =================

  // Backend API Base URL
  static const String baseUrl =
      'http://127.0.0.1:8000';

  // ================= AUTHENTICATION APIs =================

  static const String registrationEndpoint =
      '/authentication/registration';

  static const String loginEndpoint =
      '/authentication/login';

  static const String profileEndpoint =
      '/authentication/me';

  // ================= RESUME APIs =================

  static const String resumeUploadEndpoint =
      '/resume/upload';

  static const String extractResumeTextEndpoint =
      '/resume/extract-text';

  static const String cleanResumeTextEndpoint =
      '/resume/clean-text';

  static const String analyzeResumeEndpoint =
      '/resume/analyze';

  static const String debugResumeEndpoint =
      '/resume/debug';

  // ================= SCREENING APIs =================

  static const String recentScreeningsEndpoint =
      '/api/screenings/recent';

  static const String screeningHistoryEndpoint =
      '/screening-history/';

  static const String screeningEndpoint =
      '/screening';

  static const String screeningResultEndpoint =
      '/screening-result';

  // ================= NAVIGATION =================

  static const List<String> navItems = [
    'Features',
    'How It Works',
    'Pricing',
    'Contact',
  ];

  // ================= DASHBOARD NAVIGATION =================

  static const List<String> dashboardNavItems = [
    'Dashboard',
    'New Screening',
    'My Screenings',
    'Jobs',
    'Profile',
    'Settings',
  ];
}