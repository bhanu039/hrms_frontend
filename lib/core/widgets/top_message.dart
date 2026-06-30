import 'package:flutter/material.dart';

import 'package:goexperts/core/app_constants/app_color.dart';

class TopMessage {
  static void show(
    BuildContext context,
    String message, {
    required Color color,
  }) {
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 16,
        right: 16,
        child: Material(
          color: AppColors.transparent,
          child: _TopMessageWidget(message: message, color: color),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class _TopMessageWidget extends StatelessWidget {
  final String message;
  final Color color;

  const _TopMessageWidget({required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.white, fontSize: 16),
      ),
    );
  }
}
