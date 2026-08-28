import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class FeatureCardsSection extends StatelessWidget {
  const FeatureCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 24.0,
        vertical: 40.0,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (isDesktop) {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.auto_awesome_outlined,
                        title: 'Smart Matching',
                        description:
                            'AI matches skills and experience against your job requirements accurately.',
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.timer_outlined,
                        title: 'Instant Results',
                        description:
                            'Get detailed screening reports with match scores in seconds, not days.',
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.shield_outlined,
                        title: 'Better Hiring',
                        description:
                            'Find the best talent faster with objective, repeatable screening.',
                      ),
                    ),
                  ],
                );
              } else {
                return const Column(
                  children: [
                    _FeatureCard(
                      icon: Icons.auto_awesome_outlined,
                      title: 'Smart Matching',
                      description:
                          'AI matches skills and experience against your job requirements accurately.',
                    ),
                    SizedBox(height: 20),
                    _FeatureCard(
                      icon: Icons.timer_outlined,
                      title: 'Instant Results',
                      description:
                          'Get detailed screening reports with match scores in seconds, not days.',
                    ),
                    SizedBox(height: 20),
                    _FeatureCard(
                      icon: Icons.shield_outlined,
                      title: 'Better Hiring',
                      description:
                          'Find the best talent faster with objective, repeatable screening.',
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered ? AppColors.primary.withValues(alpha: 0.3) : AppColors.cardBorder,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: _isHovered ? 20 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(height: 20),

            // Card Title
            Text(
              widget.title,
              style: AppTypography.cardTitle,
            ),
            const SizedBox(height: 10),

            // Card Description
            Text(
              widget.description,
              style: AppTypography.cardBody,
            ),
          ],
        ),
      ),
    );
  }
}
