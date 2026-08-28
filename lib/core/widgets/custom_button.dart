import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum ButtonType { primary, secondary, outline, white }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final IconData? icon;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.width,
    this.height = 48,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Border? border;

    switch (widget.type) {
      case ButtonType.primary:
        backgroundColor = _isHovered ? AppColors.primaryDark : AppColors.primary;
        textColor = Colors.white;
        border = null;
        break;
      case ButtonType.secondary:
        backgroundColor = _isHovered ? const Color(0xFFE8E5FE) : AppColors.softPurple;
        textColor = AppColors.primary;
        border = null;
        break;
      case ButtonType.outline:
        backgroundColor = _isHovered ? const Color(0xFFF8FAFC) : Colors.transparent;
        textColor = AppColors.textPrimary;
        border = Border.all(color: AppColors.border, width: 1.5);
        break;
      case ButtonType.white:
        backgroundColor = _isHovered ? const Color(0xFFF1F5F9) : Colors.white;
        textColor = AppColors.primary;
        border = null;
        break;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: border,
          boxShadow: _isHovered && widget.type == ButtonType.primary
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: widget.onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 18, color: textColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: AppTypography.buttonText.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
