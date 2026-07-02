import 'package:flutter/material.dart';
import '../data/company_profile_modal.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyOverviewWidget extends StatelessWidget {
  final CompanyProfileData profile;

  const CompanyOverviewWidget({Key? key, required this.profile})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Container(
        color: AppColors.backgroundColor,
        child: ListView(
          
          padding: const EdgeInsets.all(16),
          children: [
            // Contact Information
            _buildSectionTitle('Contact Information'),
            _buildContactCard(
              icon: Icons.email,
              title: 'Email',
              value: profile.email ?? 'Not provided',
              subtitle: profile.ownerEmail != null
                  ? 'Owner: ${profile.ownerEmail}'
                  : null,
            ),
            _buildContactCard(
              icon: Icons.phone,
              title: 'Phone',
              value: profile.phone ?? 'Not provided',
            ),
            _buildContactCard(
              icon: Icons.language,
              title: 'Website',
              value: profile.website ?? 'Not provided',
            ),
            const SizedBox(height: 16),
        
            // Location Information
            _buildSectionTitle('Location'),
            if (profile.latitude != null && profile.longitude != null)
              _buildContactCard(
                icon: Icons.location_on,
                title: 'Coordinates',
                value: '${profile.latitude}, ${profile.longitude}',
                subtitle: 'Geofence Radius: ${profile.geofenceRadius ?? 0} meters',
              )
            else
              _buildContactCard(
                icon: Icons.location_on,
                title: 'Location',
                value: 'Not set',
              ),
            const SizedBox(height: 16),
        
            // Verification Status
            _buildSectionTitle('Verification Status'),
            Row(
              children: [
                Expanded(
                  child: _buildStatusChip(
                    icon: Icons.mail,
                    label: 'Email Verified',
                    isVerified: profile.isEmailVerified ?? false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatusChip(
                    icon: Icons.check_circle,
                    label: 'Profile Complete',
                    isVerified: profile.isProfileCompleted ?? false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
        
            // Dates Information
            _buildSectionTitle('Timeline'),
            if (profile.createdAt != null)
              _buildTimelineItem(
                icon: Icons.add_circle,
                title: 'Created',
                date: profile.createdAt!,
              ),
            if (profile.activatedAt != null)
              _buildTimelineItem(
                icon: Icons.check_circle,
                title: 'Activated',
                date: profile.activatedAt!,
              ),
            if (profile.lastActiveAt != null)
              _buildTimelineItem(
                icon: Icons.access_time,
                title: 'Last Active',
                date: profile.lastActiveAt!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style:  TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.brandBlue,
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side:  BorderSide(color: AppColors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.brandBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.brandBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style:  TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style:  TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:  TextStyle(fontSize: 11, color: AppColors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip({
    required IconData icon,
    required String label,
    required bool isVerified,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isVerified
            ? AppColors.green.withOpacity(0.1)
            : AppColors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isVerified ? AppColors.green : AppColors.orange,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.check_circle : Icons.schedule,
            color: isVerified ? AppColors.green : AppColors.orange,
            size: 18,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isVerified ? AppColors.green : AppColors.orange,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required DateTime date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.brandBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style:  TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black87,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _getTimeAgo(date),
            style:  TextStyle(fontSize: 12, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final duration = DateTime.now().difference(date);

    if (duration.inDays > 365) {
      return '${(duration.inDays / 365).floor()}y ago';
    } else if (duration.inDays > 30) {
      return '${(duration.inDays / 30).floor()}mo ago';
    } else if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}



