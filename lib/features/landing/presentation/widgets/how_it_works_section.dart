import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 24.0,
        vertical: 80.0,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How it works',
                style: AppTypography.sectionTitle,
              ),
              const SizedBox(height: 48),

              // Steps Grid / Row
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isDesktop) {
                    return const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _StepItem(
                            stepNumber: '01',
                            title: 'Upload resume',
                            description: 'PDF, DOC or DOCX up to 10 MB.',
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: _StepItem(
                            stepNumber: '02',
                            title: 'Add job details',
                            description: 'Job title and required skills.',
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: _StepItem(
                            stepNumber: '03',
                            title: 'AI screening',
                            description: 'Text, skills and experience extraction.',
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: _StepItem(
                            stepNumber: '04',
                            title: 'Get the report',
                            description: 'Match score, gaps and recommendation.',
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Column(
                      children: [
                        _StepItem(
                          stepNumber: '01',
                          title: 'Upload resume',
                          description: 'PDF, DOC or DOCX up to 10 MB.',
                        ),
                        SizedBox(height: 28),
                        _StepItem(
                          stepNumber: '02',
                          title: 'Add job details',
                          description: 'Job title and required skills.',
                        ),
                        SizedBox(height: 28),
                        _StepItem(
                          stepNumber: '03',
                          title: 'AI screening',
                          description: 'Text, skills and experience extraction.',
                        ),
                        SizedBox(height: 28),
                        _StepItem(
                          stepNumber: '04',
                          title: 'Get the report',
                          description: 'Match score, gaps and recommendation.',
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String description;

  const _StepItem({
    required this.stepNumber,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stepNumber,
          style: AppTypography.stepNumber,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: AppTypography.cardBody,
        ),
      ],
    );
  }
}
