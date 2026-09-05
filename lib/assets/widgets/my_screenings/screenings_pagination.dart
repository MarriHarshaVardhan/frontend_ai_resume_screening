import 'package:flutter/material.dart';

class ScreeningsPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;

  const ScreeningsPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildButton(
          context,
          icon: Icons.chevron_left,
          onTap: currentPage > 1
              ? () => onPageChanged?.call(currentPage - 1)
              : null,
        ),

        const SizedBox(width: 8),

        ...List.generate(
          totalPages,
          (index) {
            final page = index + 1;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildPageButton(
                context,
                page,
              ),
            );
          },
        ),

        _buildButton(
          context,
          icon: Icons.chevron_right,
          onTap: currentPage < totalPages
              ? () => onPageChanged?.call(currentPage + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildPageButton(
    BuildContext context,
    int page,
  ) {
    final bool isActive = page == currentPage;

    return InkWell(
      onTap: () => onPageChanged?.call(page),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF5B3DB5)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? const Color(0xFF5B3DB5)
                : const Color(0xFFD7DEE8),
          ),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive
                ? Colors.white
                : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFD7DEE8),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: onTap == null
              ? const Color(0xFFCBD5E1)
              : const Color(0xFF64748B),
        ),
      ),
    );
  }
}