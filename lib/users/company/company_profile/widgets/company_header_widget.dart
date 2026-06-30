import 'package:flutter/material.dart';
import '../data/company_profile_modal.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyHeaderWidget extends StatelessWidget {
  final CompanyProfileData profile;

  const CompanyHeaderWidget({Key? key, required this.profile})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.brandBlue,
            AppColors.brandBlue.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Company Logo
          Row(
            children: [
              SizedBox(width: 60),
              Container(
                padding: const EdgeInsets.all(4),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: profile.companyLogo != null
                      ? Image.network(
                          profile.companyLogo!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
              const SizedBox(height: 16),
              // Company Name
              Expanded(
                child: Column(
                  children: [
                    Text(
                      profile.name ?? 'Company Name',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(profile.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatStatus(profile.status),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Industry Type
                    if (profile.industryType != null)
                      Text(
                        '${profile.industryType!.name ?? 'Industry'} • ${profile.companySize ?? 'Size Unknown'}',
                        style:  TextStyle(
                          fontSize: 13,
                          color: AppColors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Info Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: profile.email?.split('@').first ?? 'N/A',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: profile.phone ?? 'N/A',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.white.withOpacity(0.3),
      child: const Icon(Icons.business, color: AppColors.white, size: 50),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(  
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.white, size: 18),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: AppColors.white),
              ),
            ],
          ),
        
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppColors.green;
      case 'inactive':
        return AppColors.orange;
      case 'pending':
        return AppColors.blue;
      case 'deleted':
        return AppColors.red;
      default:
        return AppColors.grey;
    }
  }

  String _formatStatus(String? status) {
    return status?.replaceAll('_', ' ').toUpperCase() ?? 'UNKNOWN';
  }
}



