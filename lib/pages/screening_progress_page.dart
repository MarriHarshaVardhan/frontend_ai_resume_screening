import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/user_session.dart';
import '../assets/widgets/dashboard/dashboard_sidebar.dart';

class ScreeningProgressPage extends StatelessWidget {
  const ScreeningProgressPage({super.key});

  void _handleLogout(BuildContext context) {
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

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
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

  void _handleNavItemSelect(
    BuildContext context,
    String item,
  ) {
    if (item == 'Dashboard') {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.dashboard,
      );
    } else if (item == 'New Screening') {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.newScreening,
      );
    } else if (item == 'My Screenings') {
      Navigator.pushNamed(
        context,
        AppRoutes.myScreenings,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$item page coming soon!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    final arguments =
        ModalRoute.of(context)?.settings.arguments;

    final Map<String, dynamic> data =
        arguments is Map<String, dynamic>
            ? arguments
            : {};

    final screeningId = data['screening_id'];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),

      drawer: !isDesktop
          ? Drawer(
              child: DashboardSidebar(
                activeRoute: 'New Screening',
                onItemSelected: (item) {
                  Navigator.pop(context);

                  _handleNavItemSelect(
                    context,
                    item,
                  );
                },
                onLogoutTap: () {
                  Navigator.pop(context);

                  _handleLogout(context);
                },
              ),
            )
          : null,

      body: Row(
        children: [
          if (isDesktop)
            DashboardSidebar(
              activeRoute: 'New Screening',
              onItemSelected: (item) {
                _handleNavItemSelect(
                  context,
                  item,
                );
              },
              onLogoutTap: () {
                _handleLogout(context);
              },
            ),

          Expanded(
            child: Column(
              children: [
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
                              Scaffold.of(
                                btnContext,
                              ).openDrawer();
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

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32 : 20,
                      vertical: 28,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 1120,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Screening in Progress',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              "Please don't close this window. AI is analyzing the resume.",
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),

                            const SizedBox(height: 28),

                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(
                                    0xFFE5E7EB,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(
                                      alpha: 0.04,
                                    ),
                                    blurRadius: 8,
                                    offset:
                                        const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  LayoutBuilder(
                                    builder: (
                                      context,
                                      constraints,
                                    ) {
                                      final isSmall =
                                          constraints.maxWidth <
                                              650;

                                      if (isSmall) {
                                        return Column(
                                          children: [
                                            _buildSteps(),

                                            const SizedBox(
                                              height: 35,
                                            ),

                                            _buildProgressIndicator(),
                                          ],
                                        );
                                      }

                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Expanded(
                                            child:
                                                _buildSteps(),
                                          ),

                                          const SizedBox(
                                            width: 40,
                                          ),

                                          SizedBox(
                                            width: 320,
                                            child:
                                                _buildProgressIndicator(),
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 28),

                                  Container(
                                    width: double.infinity,
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 13,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color(0xFFF1F5F9),
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration:
                                              BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  const Color(
                                                0xFF6C5CE7,
                                              ),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'i',
                                              style: TextStyle(
                                                fontFamily:
                                                    'Segoe UI',
                                                fontSize: 10,
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                                color: Color(
                                                  0xFF6C5CE7,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        const Text(
                                          'This may take a few seconds...',
                                          style: TextStyle(
                                            fontFamily:
                                                'Segoe UI',
                                            fontSize: 14,
                                            color: Color(
                                              0xFF64748B,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Align(
                                    alignment:
                                        Alignment.centerLeft,
                                    child: OutlinedButton(
                                      onPressed:
                                          screeningId == null
                                              ? null
                                              : () {
                                                  Navigator
                                                      .pushNamed(
                                                    context,
                                                    AppRoutes
                                                        .screeningResult,
                                                    arguments: {
                                                      'screening_id':
                                                          screeningId,
                                                    },
                                                  );
                                                },
                                      style:
                                          OutlinedButton.styleFrom(
                                        backgroundColor:
                                            Colors.white,
                                        foregroundColor:
                                            const Color(
                                          0xFF111827,
                                        ),
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                          horizontal: 16,
                                          vertical: 13,
                                        ),
                                        side:
                                            const BorderSide(
                                          color: Color(
                                            0xFFE5E7EB,
                                          ),
                                        ),
                                        shape:
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'View Result',
                                        style: TextStyle(
                                          fontFamily:
                                              'Segoe UI',
                                          fontSize: 14,
                                          fontWeight:
                                              FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

  Widget _buildSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompletedStep('Extracting Text'),

        const SizedBox(height: 18),

        _buildCompletedStep('Extracting Skills'),

        const SizedBox(height: 18),

        _buildCompletedStep('Extracting Experience'),

        const SizedBox(height: 18),

        _buildCompletedStep('Matching with Job'),

        const SizedBox(height: 18),

        _buildCompletedStep('Calculating Score'),

        const SizedBox(height: 18),

        _buildCompletedStep('Generating Result'),
      ],
    );
  }

  Widget _buildCompletedStep(String title) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF169B62),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 16,
          ),
        ),

        const SizedBox(width: 12),

        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 158,
          height: 158,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 158,
                height: 158,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 13,
                  backgroundColor:
                      Colors.transparent,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(
                    Color(0xFFF0F2F7),
                  ),
                ),
              ),

              SizedBox(
                width: 158,
                height: 158,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 13,
                  strokeCap: StrokeCap.round,
                  backgroundColor:
                      Colors.transparent,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(
                    Color(0xFF6038C8),
                  ),
                ),
              ),

              const Text(
                '100%',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Resume analysis completed',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12,
            color: Color(0xFF7A8494),
          ),
        ),
      ],
    );
  }
}