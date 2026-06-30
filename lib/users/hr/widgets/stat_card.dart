import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String? count;
  final IconData? icon;
  final Color? color;

  const StatCard({
    super.key,
    required this.title,
    this.count,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.indigo, size: 30),
          const SizedBox(height: 10),
          Text(
            count ?? "",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style:  TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }
}
