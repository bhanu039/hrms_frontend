import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class TaskTile extends StatelessWidget {
  final String title;
  const TaskTile({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
           Icon(Icons.warning_amber_rounded, color: AppColors.orange),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
