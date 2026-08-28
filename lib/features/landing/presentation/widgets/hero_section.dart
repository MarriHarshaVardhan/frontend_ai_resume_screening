import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';
import 'hero_illustration.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onGetStartedTap;
  final VoidCallback? onLearnMoreTap;

  const HeroSection({
    super.key,
    this.onGetStartedTap,
    this.onLearnMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 24.0,
        vertical: isDesktop ? 60.0 : 36.0,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Column: Text & CTAs
              Expanded(
                flex: isDesktop ? 6 : 0,
                child: Column(
                  crossAxisAlignment: isDesktop
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    // Soft Purple Pill Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Resume screening, automated',
                        style: AppTypography.badgeText,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Headline
                    RichText(
                      textAlign:
                          isDesktop ? TextAlign.left : TextAlign.center,
                      text: const TextSpan(
                        style: AppTypography.heroTitle,
                        children: [
                          TextSpan(text: 'AI Powered\n'),
                          TextSpan(
                            text: 'Resume Screening',
                            style: AppTypography.heroTitleAccent,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Subtitle Copy
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Text(
                        'Upload resumes, match skills, and find the best candidates for your job in minutes.',
                        textAlign:
                            isDesktop ? TextAlign.left : TextAlign.center,
                        style: AppTypography.heroSubtitle,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons Row
                    Row(
                      mainAxisAlignment: isDesktop
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: 'Get Started',
                          onPressed: onGetStartedTap ?? () {},
                          type: ButtonType.primary,
                          height: 48,
                        ),
                        const SizedBox(width: 14),
                        CustomButton(
                          text: 'Learn More',
                          onPressed: onLearnMoreTap ?? () {},
                          type: ButtonType.outline,
                          height: 48,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (!isDesktop) const SizedBox(height: 48),

              // Right Column: Hero Graphic Illustration
              Expanded(
                flex: isDesktop ? 5 : 0,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: HeroIllustration(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
