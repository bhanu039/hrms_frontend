import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyProfileHeader extends StatelessWidget {
  const CompanyProfileHeader({
    super.key,
    required this.companyName,
    required this.email,
  });

  final String companyName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          colors: [AppColors.tealBrand, AppColors.info],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
           CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.white,
            child: Icon(Icons.business, size: 38, color: AppColors.tealBrand),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
