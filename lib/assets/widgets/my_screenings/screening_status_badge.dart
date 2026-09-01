import 'package:flutter/material.dart';

class ScreeningStatusBadge extends StatelessWidget {
  final String status;

  const ScreeningStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status.toLowerCase() == 'completed';

    final Color backgroundColor = isCompleted
        ? const Color(0xFFDDF3E5)
        : const Color(0xFFF8ECCD);

    final Color textColor = isCompleted
        ? const Color(0xFF287A4D)
        : const Color(0xFF8A6418);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}