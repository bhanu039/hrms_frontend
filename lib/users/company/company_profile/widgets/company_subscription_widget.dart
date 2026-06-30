import 'package:flutter/material.dart';
import '../data/company_profile_modal.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanySubscriptionWidget extends StatelessWidget {
  final CompanyProfileData profile;

  const CompanySubscriptionWidget({Key? key, required this.profile})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subscription = profile.currentSubscription;

    if (subscription == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_giftcard,
              size: 64,
              color: AppColors.grey.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
             Text(
              'No Active Subscription',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
             Text(
              'Upgrade to unlock premium features',
              style: TextStyle(fontSize: 12, color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Browse Plans'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Main Plan Card
          _buildPlanCard(context, subscription),
          const SizedBox(height: 20),
      
          // Plan Details
          _buildSectionTitle('Plan Details'),
          _buildDetailRow('Plan Name', subscription.plan?.name ?? 'N/A'),
          _buildDetailRow('Price', '\$${subscription.plan?.price ?? 0}'),
          _buildDetailRow(
            'Duration',
            '${subscription.plan?.duration ?? 0} months',
          ),
          const SizedBox(height: 20),
      
          // Subscription Timeline
          _buildSectionTitle('Subscription Timeline'),
          _buildTimelineRow(
            icon: Icons.play_circle,
            title: 'Start Date',
            date: subscription.startDate,
          ),
          _buildTimelineRow(
            icon: Icons.stop_circle,
            title: 'End Date',
            date: subscription.endDate,
            isWarning: _isEndingSoon(subscription.endDate),
          ),
          const SizedBox(height: 20),
      
          // Features
          if (subscription.plan?.features != null &&
              (subscription.plan!.features as Map).isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Features Included'),
                _buildFeaturesList(
                  subscription.plan!.features as Map<String, dynamic>,
                ),
              ],
            ),
          const SizedBox(height: 20),
      
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upgrade),
                  label: const Text('Upgrade Plan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlue,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red,
                    side:  BorderSide(color: AppColors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    CurrentSubscription subscription,
  ) {
    final isActive = subscription.isSubscriptionActive ?? false;
    final plan = subscription.plan;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isActive
              ? [
                  AppColors.brandBlue,
                  AppColors.brandBlue.withOpacity(0.8),
                ]
              : [AppColors.grey, AppColors.grey.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan?.name ?? 'Plan',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isActive ? Icons.check_circle : Icons.schedule,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${plan?.price ?? 0}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: 1,
                color: AppColors.white.withOpacity(0.2),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Days Remaining',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_getDaysRemaining(subscription.endDate)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:  TextStyle(
              fontSize: 14,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style:  TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineRow({
    required IconData icon,
    required String title,
    DateTime? date,
    bool isWarning = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isWarning ? AppColors.orange : AppColors.brandBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:   TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date != null
                      ? '${date.day}/${date.month}/${date.year}'
                      : 'N/A',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isWarning ? AppColors.orange : AppColors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (isWarning)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child:  Text(
                'Ending Soon',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(Map<String, dynamic> features) {
    return Column(
      children: features.entries.map((entry) {
        final isEnabled = entry.value is bool ? entry.value : true;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Icon(
                isEnabled ? Icons.check_circle : Icons.lock,
                color: isEnabled ? AppColors.green : AppColors.grey,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 13,
                    color: isEnabled ? AppColors.black87 : AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  int _getDaysRemaining(DateTime? endDate) {
    if (endDate == null) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }

  bool _isEndingSoon(DateTime? endDate) {
    if (endDate == null) return false;
    final daysRemaining = _getDaysRemaining(endDate);
    return daysRemaining <= 30 && daysRemaining > 0;
  }
}



