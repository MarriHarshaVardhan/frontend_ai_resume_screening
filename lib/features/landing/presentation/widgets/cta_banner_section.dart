import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';

class CtaBannerSection extends StatelessWidget {
  final VoidCallback? onCreateAccountTap;

  const CtaBannerSection({
    super.key,
    this.onCreateAccountTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 24.0,
        vertical: 60.0,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 56.0 : 28.0,
            vertical: isDesktop ? 48.0 : 36.0,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.ctaGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Start screening for free',
                style: AppTypography.ctaTitle,
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: const Text(
                  '10 screenings per month on the free plan. Upgrade any time for bulk uploads and job libraries.',
                  style: AppTypography.ctaSubtitle,
                ),
              ),
              const SizedBox(height: 28),
              CustomButton(
                text: 'Create your account',
                onPressed: onCreateAccountTap ?? () {},
                type: ButtonType.white,
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
