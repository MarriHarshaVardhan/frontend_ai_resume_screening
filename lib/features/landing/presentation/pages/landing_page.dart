import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_nav_bar.dart';
import '../../../../core/widgets/app_footer.dart';
import '../widgets/hero_section.dart';
import '../widgets/feature_cards_section.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/cta_banner_section.dart';

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
          ],
        ),
      ),
      body: Column(
        children: [
          // Sticky Top Navigation Bar
          AppNavBar(
            onNavItemTap: _handleNavTap,
            onLoginTap: () {
              // Navigation to future Login screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login screen planned for next phase!')),
              );
            },
          ),

          // Main Scrollable Page Body
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  HeroSection(
                    onGetStartedTap: () => _scrollToSection(_pricingKey),
                    onLearnMoreTap: () => _scrollToSection(_howItWorksKey),
                  ),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account Creation flow planned!'),
                          ),
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
}
