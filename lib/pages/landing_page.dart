import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../assets/widgets/common/app_nav_bar.dart';
import '../assets/widgets/common/app_footer.dart';
import '../assets/widgets/landing/hero_section.dart';
import '../assets/widgets/landing/feature_cards_section.dart';
import '../assets/widgets/landing/how_it_works_section.dart';
import '../assets/widgets/landing/cta_banner_section.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleNavTap(String item) {
    switch (item) {
      case 'Features':
        _scrollToSection(_featuresKey);
        break;

      case 'How It Works':
        _scrollToSection(_howItWorksKey);
        break;

      case 'Pricing':
        _scrollToSection(_pricingKey);
        break;

      case 'Contact':
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Center(
                child: Text(
                  AppConstants.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...AppConstants.navItems.map((item) {
              return ListTile(
                title: Text(item),
                onTap: () {
                  Navigator.pop(context);
                  _handleNavTap(item);
                },
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.admin_panel_settings_outlined,
              ),
              title: const Text(
                'Admin Login',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(
                  context,
                  AppRoutes.adminLogin,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          AppNavBar(
            onNavItemTap: _handleNavTap,
            onLoginTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.login,
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  HeroSection(
                    onGetStartedTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.registration,
                      );
                    },
                    onLearnMoreTap: () {
                      _scrollToSection(
                        _howItWorksKey,
                      );
                    },
                  ),

                  _buildAccessSection(),

                  Container(
                    key: _featuresKey,
                    child: const FeatureCardsSection(),
                  ),

                  Container(
                    key: _howItWorksKey,
                    child: const HowItWorksSection(),
                  ),

                  Container(
                    key: _pricingKey,
                    child: CtaBannerSection(
                      onCreateAccountTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.registration,
                        );
                      },
                    ),
                  ),

                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: Text(
                  'OR CONTINUE AS',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen =
                  constraints.maxWidth < 650;

              if (isSmallScreen) {
                return Column(
                  children: [
                    _buildAccessCard(
                      title: "I'm a Candidate",
                      subtitle: 'Register / Login',
                      icon: Icons.person_outline,
                      borderColor: AppColors.primary,
                      iconColor: AppColors.primary,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.registration,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildAccessCard(
                      title: "I'm an Admin",
                      subtitle: 'Admin Login',
                      icon:
                          Icons.admin_panel_settings_outlined,
                      borderColor: Colors.redAccent,
                      iconColor: Colors.redAccent,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.adminLogin,
                        );
                      },
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: _buildAccessCard(
                      title: "I'm a Candidate",
                      subtitle: 'Register / Login',
                      icon: Icons.person_outline,
                      borderColor: AppColors.primary,
                      iconColor: AppColors.primary,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.registration,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildAccessCard(
                      title: "I'm an Admin",
                      subtitle: 'Admin Login',
                      icon:
                          Icons.admin_panel_settings_outlined,
                      borderColor: Colors.redAccent,
                      iconColor: Colors.redAccent,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.adminLogin,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccessCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color borderColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: borderColor.withValues(alpha: 0.65),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}