import 'package:flutter/material.dart';

import 'match_score_circle.dart';

class CandidateResultHeader extends StatelessWidget {
  final String candidateName;
  final String jobRole;
  final double matchScore;

  // Download function
  final VoidCallback? onDownload;

  const CandidateResultHeader({
    super.key,
    required this.candidateName,
    required this.jobRole,
    required this.matchScore,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          MatchScoreCircle(
            score: matchScore,
          ),

          const SizedBox(width: 24),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  candidateName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  jobRole,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F4E8),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Good Match',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16804B),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Candidate has a strong match for this job role.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5A6472),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // ONLY GREEN DOWNLOAD BUTTON
          ElevatedButton.icon(
            onPressed: onDownload,
            icon: const Icon(Icons.download),
            label: const Text('Download Report'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF16804B),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}