import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import 'custom_button.dart';

class AppNavBar extends StatelessWidget {
  final Function(String item)? onNavItemTap;
  final VoidCallback? onLoginTap;

  const AppNavBar({
    super.key,
    this.onNavItemTap,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 850;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 20.0,
        vertical: 16.0,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand Logo & Title
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF654CE5), Color(0xFF8F75FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.document_scanner_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),

              // Desktop Navigation Links
              if (isDesktop)
                Row(
                  children: AppConstants.navItems.map((item) {
                    return _NavLink(
                      title: item,
                      onTap: () => onNavItemTap?.call(item),
                    );
                  }).toList(),
                ),

              // Action / Login Button
              Row(
                children: [
                  CustomButton(
                    text: 'Login',
                    onPressed: onLoginTap ?? () {},
                    type: ButtonType.primary,
                    height: 40,
                  ),
                  if (!isDesktop) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavLink({
    required this.title,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            widget.title,
            style: AppTypography.navLink.copyWith(
              color: _isHovered ? AppColors.primary : AppColors.textSecondary,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
