import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HeroIllustration extends StatelessWidget {
  const HeroIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      width: 440,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Background soft glow
          Positioned(
            top: 40,
            right: 40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.06),
              ),
            ),
          ),

          // Main Illustration Body - Custom Canvas Painting
          Positioned.fill(
            child: CustomPaint(
              painter: _HeroIllustrationPainter(),
            ),
          ),

          // Candidate Profile Avatar Float (Top Right)
          Positioned(
            top: 30,
            right: 110,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFFE0E7FF),
                child: Icon(Icons.person, color: AppColors.primary, size: 30),
              ),
            ),
          ),

          // Magnifying Glass Accent (Right Side)
          Positioned(
            right: 15,
            top: 80,
            child: Transform.rotate(
              angle: 0.45,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3B82F6), width: 7),
                ),
                child: Center(
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF93C5FD).withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 175,
            child: Transform.rotate(
              angle: -0.85,
              child: Container(
                width: 14,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Floating Sparkle / AI Tag
          Positioned(
            left: 20,
            top: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.primary, size: 16),
                  SizedBox(width: 6),
                  Text(
                    '98% Match',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
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

class _HeroIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.45, size.height * 0.55);

    // Dark Navy / Blue Pants
    final pantsPaint = Paint()
      ..color = const Color(0xFF1E1B4B)
      ..style = PaintingStyle.fill;

    // Left Leg
    final leftLeg = RRect.fromLTRBR(
      center.dx - 30,
      center.dy + 40,
      center.dx - 10,
      center.dy + 160,
      const Radius.circular(8),
    );
    canvas.drawRRect(leftLeg, pantsPaint);

    // Right Leg
    final rightLeg = RRect.fromLTRBR(
      center.dx + 5,
      center.dy + 40,
      center.dx + 25,
      center.dy + 160,
      const Radius.circular(8),
    );
    canvas.drawRRect(rightLeg, pantsPaint);

    // Shoes
    final shoesPaint = Paint()..color = const Color(0xFF4F46E5);
    canvas.drawRRect(
      RRect.fromLTRBR(center.dx - 38, center.dy + 155, center.dx - 5, center.dy + 168, const Radius.circular(6)),
      shoesPaint,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(center.dx + 5, center.dy + 155, center.dx + 38, center.dy + 168, const Radius.circular(6)),
      shoesPaint,
    );

    // Jacket (Bright Royal Blue)
    final jacketPaint = Paint()..color = const Color(0xFF3B82F6);
    final jacketRect = RRect.fromLTRBR(
      center.dx - 45,
      center.dy - 60,
      center.dx + 40,
      center.dy + 45,
      const Radius.circular(16),
    );
    canvas.drawRRect(jacketRect, jacketPaint);

    // Inner Shirt (White)
    final shirtPaint = Paint()..color = Colors.white;
    final shirtPath = Path()
      ..moveTo(center.dx - 12, center.dy - 60)
      ..lineTo(center.dx + 8, center.dy - 60)
      ..lineTo(center.dx - 2, center.dy + 20)
      ..close();
    canvas.drawPath(shirtPath, shirtPaint);

    // Head / Face (Skin tone)
    final skinPaint = Paint()..color = const Color(0xFFFDE68A);
    canvas.drawCircle(Offset(center.dx - 2, center.dy - 85), 22, skinPaint);

    // Hair (Dark navy)
    final hairPaint = Paint()..color = const Color(0xFF0F172A);
    final hairPath = Path()
      ..addArc(
        Rect.fromCircle(center: Offset(center.dx - 2, center.dy - 90), radius: 24),
        -3.14,
        3.14,
      );
    canvas.drawPath(hairPath, hairPaint);

    // Laptop (Light blue/gray held in hands)
    final laptopPaint = Paint()..color = const Color(0xFF93C5FD);
    final laptopRect = RRect.fromLTRBR(
      center.dx + 5,
      center.dy - 25,
      center.dx + 70,
      center.dy + 15,
      const Radius.circular(8),
    );
    canvas.drawRRect(laptopRect, laptopPaint);

    // Laptop Screen Light
    final laptopScreenPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromLTRBR(
        center.dx + 12,
        center.dy - 20,
        center.dx + 63,
        center.dy + 10,
        const Radius.circular(4),
      ),
      laptopScreenPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
