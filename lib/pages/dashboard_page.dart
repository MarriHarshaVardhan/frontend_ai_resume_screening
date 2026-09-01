import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/user_session.dart';

import '../assets/widgets/dashboard/dashboard_sidebar.dart';
import '../assets/widgets/dashboard/dashboard_header.dart';
import '../assets/widgets/dashboard/dashboard_stat_card.dart';
import '../assets/widgets/dashboard/recent_screenings_table.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedRoute = 'Dashboard';

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout of your account?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                UserSession.logout();

                Navigator.pop(dialogContext);

                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.login,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Navigation Handler
  void _handleNavItemSelect(String item) {
    setState(() {
      _selectedRoute = item;
    });

    // Dashboard
    if (item == 'Dashboard') {
      return;
    }

    // New Screening
    if (item == 'New Screening') {
      Navigator.pushNamed(
        context,
        AppRoutes.newScreening,
      );
      return;
    }

    // My Screenings
    if (item == 'My Screenings') {
      Navigator.pushNamed(
        context,
        AppRoutes.myScreenings,
      );
      return;
    }

    // Other Pages
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$item page coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.background,

      // Mobile Drawer
      drawer: !isDesktop
          ? Drawer(
              child: DashboardSidebar(
                activeRoute: _selectedRoute,
                onItemSelected: (item) {
                  Navigator.pop(context);
                  _handleNavItemSelect(item);
                },
                onLogoutTap: () {
                  Navigator.pop(context);
                  _handleLogout();
                },
              ),
            )
          : null,

      body: Row(
        children: [
          // Desktop Sidebar
          if (isDesktop)
            DashboardSidebar(
              activeRoute: _selectedRoute,
              onItemSelected: _handleNavItemSelect,
              onLogoutTap: _handleLogout,
            ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Mobile Header
                if (!isDesktop)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Builder(
                          builder: (btnContext) => IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: AppColors.textPrimary,
                            ),
                            onPressed: () {
                              Scaffold.of(btnContext).openDrawer();
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        const Text(
                          'AI Resume Screener',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Dashboard Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 36.0 : 16.0,
                      vertical: 28.0,
                    ),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 1200,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            Builder(
                              builder: (context) {
                                final args = ModalRoute.of(context)
                                    ?.settings
                                    .arguments;

                                String currentUserName =
                                    UserSession.userName;

                                String currentUserInitials =
                                    UserSession.initials;

                                if (args is Map<String, dynamic>) {
                                  if (args['name'] != null &&
                                      (args['name'] as String)
                                          .trim()
                                          .isNotEmpty) {
                                    currentUserName =
                                        (args['name'] as String).trim();
                                  }

                                  if (args['initials'] != null &&
                                      (args['initials'] as String)
                                          .trim()
                                          .isNotEmpty) {
                                    currentUserInitials =
                                        (args['initials'] as String)
                                            .trim();
                                  }
                                } else if (args is String &&
                                    args.trim().isNotEmpty) {
                                  currentUserName = args.trim();
                                }

                                return DashboardHeader(
                                  userName: currentUserName,
                                  subtitle:
                                      "Here's what's happening with your screenings.",
                                  userInitials: currentUserInitials,

                                  onNotificationTap: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('No new notifications'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },

                                  onProfileTap: () {
                                    _handleNavItemSelect('Profile');
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            // Statistics Cards
                            _buildStatCards(screenWidth),

                            const SizedBox(height: 28),

                            // Recent Screenings
                            RecentScreeningsTable(
                              onViewAllTap: () {
                                _handleNavItemSelect(
                                  'My Screenings',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(double screenWidth) {
    const statCards = [
      DashboardStatCard(
        label: 'Total Screenings',
        value: '24',
      ),
      DashboardStatCard(
        label: 'Completed',
        value: '18',
      ),
      DashboardStatCard(
        label: 'In Progress',
        value: '3',
      ),
      DashboardStatCard(
        label: 'Average Match Score',
        value: '78%',
      ),
    ];

    // Desktop
    if (screenWidth > 1050) {
      return Row(
        children: statCards.map((card) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
              ),
              child: card,
            ),
          );
        }).toList(),
      );
    }

    // Tablet
    else if (screenWidth > 600) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: statCards[0]),
              const SizedBox(width: 12),
              Expanded(child: statCards[1]),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: statCards[2]),
              const SizedBox(width: 12),
              Expanded(child: statCards[3]),
            ],
          ),
        ],
      );
    }

    // Mobile
    else {
      return Column(
        children: statCards.map((card) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 12.0,
            ),
            child: card,
          );
        }).toList(),
      );
    }
  }
}