import 'package:flutter/material.dart';

class SkillsResultCard extends StatelessWidget {
  final String title;
  final List<String> skills;
  final bool isMatched;

  const SkillsResultCard({
    super.key,
    required this.title,
    required this.skills,
    required this.isMatched,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isMatched
        ? const Color(0xFF16804B)
        : const Color(0xFFD9534F);

    final backgroundColor = isMatched
        ? const Color(0xFFE8F5EE)
        : const Color(0xFFFDECEC);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title (${skills.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),

          const SizedBox(height: 15),

          ...skills.map(
            (skill) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isMatched ? Icons.check : Icons.close,
                      size: 15,
                      color: iconColor,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    skill,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF3D4654),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}