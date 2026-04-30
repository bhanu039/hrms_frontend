import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/bloc/auth/auth_bloc.dart';
import '../widgets/company_info_section.dart';
import '../widgets/company_info_tile.dart';
import '../widgets/company_profile_header.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthBloc>().state.session;
    final companyName = _displayValue(session?.name, fallback: 'Company');
    final email = _displayValue(session?.email);
    final role = _displayValue(session?.role);
    final companyId = _displayValue(session?.id);

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        title: const Text('Company Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CompanyProfileHeader(companyName: companyName, email: email),
            const SizedBox(height: 16),
            CompanyInfoSection(
              title: 'Company Details',
              icon: Icons.business,
              children: [
                CompanyInfoTile(
                  icon: Icons.badge,
                  title: 'Company ID',
                  value: companyId,
                ),
                CompanyInfoTile(
                  icon: Icons.business_center,
                  title: 'Company Name',
                  value: companyName,
                ),
                CompanyInfoTile(
                  icon: Icons.email,
                  title: 'Company Email',
                  value: email,
                ),
                CompanyInfoTile(
                  icon: Icons.verified_user,
                  title: 'Account Role',
                  value: role,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _industrySection(),
            const SizedBox(height: 16),
            _companyContactSection(),
            const SizedBox(height: 16),
            _operationsSection(),
            const SizedBox(height: 16),
            _subscriptionSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static String _displayValue(String? value, {String fallback = 'Not set'}) {
    if (value == null || value.trim().isEmpty) return fallback;
    return value.trim();
  }

  Widget _industrySection() {
    return const CompanyInfoSection(
      title: 'Industry Information',
      icon: Icons.factory,
      children: [
        CompanyInfoTile(
          icon: Icons.category,
          title: 'Industry Type',
          value: 'Not set',
        ),
        CompanyInfoTile(
          icon: Icons.workspace_premium,
          title: 'Services',
          value: 'Not set',
        ),
        CompanyInfoTile(
          icon: Icons.flag,
          title: 'Specialization',
          value: 'Not set',
        ),
        CompanyInfoTile(
          icon: Icons.description,
          title: 'About Company',
          value: 'Not set',
        ),
      ],
    );
  }

  Widget _companyContactSection() {
    return const CompanyInfoSection(
      title: 'Contact & Location',
      icon: Icons.location_on,
      children: [
        CompanyInfoTile(
          icon: Icons.phone,
          title: 'Phone Number',
          value: 'Not set',
        ),
        CompanyInfoTile(
          icon: Icons.language,
          title: 'Website / Domain',
          value: 'Not set',
        ),
        CompanyInfoTile(icon: Icons.place, title: 'Location', value: 'Not set'),
        CompanyInfoTile(icon: Icons.map, title: 'Address', value: 'Not set'),
      ],
    );
  }

  Widget _operationsSection() {
    return const CompanyInfoSection(
      title: 'Operations',
      icon: Icons.account_tree,
      children: [
        CompanyInfoTile(
          icon: Icons.people,
          title: 'Employees',
          value: 'Not set',
        ),
        CompanyInfoTile(
          icon: Icons.supervisor_account,
          title: 'HR Team',
          value: 'Not set',
        ),
        CompanyInfoTile(
          icon: Icons.apartment,
          title: 'Departments',
          value: 'Not set',
        ),
        CompanyInfoTile(icon: Icons.work, title: 'Projects', value: 'Not set'),
      ],
    );
  }

  Widget _subscriptionSection() {
    return const CompanyInfoSection(
      title: 'Subscription & Status',
      icon: Icons.subscriptions,
      children: [
        CompanyInfoTile(
          icon: Icons.check_circle,
          title: 'Company Status',
          value: 'Active',
        ),
        CompanyInfoTile(
          icon: Icons.card_membership,
          title: 'Current Plan',
          value: 'Not set',
        ),
        CompanyInfoTile(
          icon: Icons.event,
          title: 'Plan Expiry',
          value: 'Not set',
        ),
      ],
    );
  }
}
