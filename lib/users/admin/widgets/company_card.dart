import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyCard extends StatelessWidget {
  final Map company;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CompanyCard({
    super.key,
    required this.company,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              const SizedBox(width: 12),
              _buildDetails(),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child:  Icon(
        Icons.business,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company['name'] ?? '',
            style:  TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 6),
          _infoRow(Icons.email, company['email']),
          const SizedBox(height: 4),
          _infoRow(Icons.language, company['domain']),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        IconButton(
          icon:  Icon(
            Icons.edit,
            color: AppColors.primary,
          ),
          onPressed: onEdit,
        ),
        IconButton(
          icon:  Icon(
            Icons.delete,
            color: AppColors.errorColor,
          ),
          onPressed: onDelete,
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, dynamic text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textSecondaryColor,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text?.toString() ?? '',
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(
              fontSize: 13,
              color: AppColors.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}