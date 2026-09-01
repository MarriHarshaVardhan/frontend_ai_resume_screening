import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';
import '../assets/widgets/screening_result/candidate_result_header.dart';
import '../assets/widgets/screening_result/result_info_card.dart';
import '../assets/widgets/screening_result/skills_result_card.dart';
import '../assets/widgets/screening_result/recommendation_card.dart';

class ScreeningResultPage extends StatelessWidget {
  const ScreeningResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        title: const Text(
          'Screening Result',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3748),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboard,
                (route) => false,
              );
            },
            icon: const Icon(Icons.dashboard_outlined, size: 18),
            label: const Text('Dashboard'),
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Page Title
            const Text(
              'Screening Result',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'AI analysis result for this candidate',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 24),

            // Candidate Header
            const CandidateResultHeader(
              candidateName: 'Ravi Kumar',
              jobRole: 'AI Engineer',
              matchScore: 85,
            ),

            const SizedBox(height: 24),

            // Candidate Information
            const Text(
              'Candidate Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),

            const SizedBox(height: 16),

            // Info Cards
            Row(
              children: [
                Expanded(
                  child: ResultInfoCard(
                    title: 'Experience',
                    value: '3.5 Years',
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ResultInfoCard(
                    title: 'Qualification',
                    value: 'B.Tech in CSE',
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ResultInfoCard(
                    title: 'Certifications',
                    value: 'AWS Certified ML',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Skills Section
            const Text(
              'Skills Analysis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SkillsResultCard(
                    title: 'Matched Skills',
                    isMatched: true,
                    skills: [
                      'Python',
                      'Machine Learning',
                      'SQL',
                      'Pandas',
                      'Scikit-learn',
                      'NLP',
                      'Data Analysis',
                      'TensorFlow',
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: SkillsResultCard(
                    title: 'Missing Skills',
                    isMatched: false,
                    skills: [
                      'Deep Learning',
                      'AWS',
                      'Docker',
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Recommendation
            const RecommendationCard(
              recommendation:
                  'Candidate has good skills and relevant experience. '
                  'Recommended for the next interview round.',
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}