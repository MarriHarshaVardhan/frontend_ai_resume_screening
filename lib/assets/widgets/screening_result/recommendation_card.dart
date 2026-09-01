import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final String recommendation;

  const RecommendationCard({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F4E8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF9BD3AC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommendation',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF287044),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            recommendation,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF3D4654),
            ),
          ),
        ],
      ),
    );
  }
}