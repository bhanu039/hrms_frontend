import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyTile extends StatelessWidget {
  final String name;
  final String status;
  const CompanyTile({super.key, required this.name, required this.status});
  @override
  Widget build(BuildContext context) {
    bool isActive = status == "Active";
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.business, color: AppColors.white),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(name)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isActive ? AppColors.green.shade100 : AppColors.red.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isActive ? AppColors.green : AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
