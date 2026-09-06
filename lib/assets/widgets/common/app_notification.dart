import 'dart:async';

import 'package:flutter/material.dart';

enum NotificationType {
  success,
  error,
  info,
}

class AppNotification {
  static OverlayEntry? _currentEntry;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _removeCurrent();

    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 20,
        right: 20,
        child: _NotificationCard(
          message: message,
          type: type,
        ),
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _timer = Timer(duration, () {
      if (entry.mounted) {
        entry.remove();
      }

      if (_currentEntry == entry) {
        _currentEntry = null;
      }
    });
  }

  static void success(
    BuildContext context,
    String message,
  ) {
    show(
      context,
      message: message,
      type: NotificationType.success,
    );
  }

  static void error(
    BuildContext context,
    String message,
  ) {
    show(
      context,
      message: message,
      type: NotificationType.error,
    );
  }

  static void info(
    BuildContext context,
    String message,
  ) {
    show(
      context,
      message: message,
      type: NotificationType.info,
    );
  }

  static void _removeCurrent() {
    _timer?.cancel();
    _timer = null;

    if (_currentEntry != null && _currentEntry!.mounted) {
      _currentEntry!.remove();
    }

    _currentEntry = null;
  }
}

class _NotificationCard extends StatelessWidget {
  final String message;
  final NotificationType type;

  const _NotificationCard({
    required this.message,
    required this.type,
  });

  Color get _color {
    switch (type) {
      case NotificationType.success:
        return const Color(0xFF16A34A);

      case NotificationType.error:
        return const Color(0xFFDC2626);

      case NotificationType.info:
        return const Color(0xFF2563EB);
    }
  }

  Color get _backgroundColor {
    switch (type) {
      case NotificationType.success:
        return const Color(0xFFF0FDF4);

      case NotificationType.error:
        return const Color(0xFFFEF2F2);

      case NotificationType.info:
        return const Color(0xFFEFF6FF);
    }
  }

  IconData get _icon {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline;

      case NotificationType.error:
        return Icons.error_outline;

      case NotificationType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 360,
        constraints: const BoxConstraints(
          minHeight: 64,
          maxHeight: 100,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _color.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              _icon,
              color: _color,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}