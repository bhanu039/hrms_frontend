import 'package:flutter/material.dart';

import '../../../core/services/api_service.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyViewScreen extends StatefulWidget {
  final Map company;

  const CompanyViewScreen({super.key, required this.company});

  @override
  State<CompanyViewScreen> createState() => _CompanyViewScreenState();
}

class _CompanyViewScreenState extends State<CompanyViewScreen> {
  late Map company;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    company = Map.of(widget.company);
  }

  String _value(String key) {
    final value = company[key];
    if (value == null) return 'Not set';
    return value.toString();
  }

  String _statusText() {
    final status = (company['status'] ?? '').toString().toLowerCase();
    final activeFlag = company['active'];
    if (activeFlag == true || status == 'active') return 'Active';
    if (status == 'inactive' || activeFlag == false) return 'Inactive';
    return 'Unknown';
  }

  Future<void> _activateCompany() async {
    setState(() => isLoading = true);

    final companyId = company['id'] ?? company['companyId'] ?? company['_id'];
    if (companyId == null) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Company id not available for activation.'),
        ),
      );
      return;
    }

    try {
      final response = await ApiService.activateCompany(companyId.toString());

      final data = response.data;
      final success = data is Map<String, dynamic> && data['success'] == true;
      final message = data is Map<String, dynamic>
          ? (data['message']?.toString() ?? 'Activation failed')
          : response.statusMessage ?? 'Activation failed';

      if (success) {
        if (!mounted) return;
        setState(() {
          company['active'] = true;
          company['status'] = 'active';
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _statusWidget(String status) {
    if (status.toLowerCase() == 'active') {
      return _statusChip(status);
    }

    return ElevatedButton.icon(
      onPressed: isLoading ? null : _activateCompany,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              ),
            )
          : const Icon(Icons.check, size: 16),
      label: Text(isLoading ? 'Activating...' : 'Activate Company'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  bool _isEmailVerified() {
    final verified =
        company['emailverify'] ??
        company['emailVerified'] ??
        company['email_verify'] ??
        company['isEmailVerified'];

    if (verified is bool) return verified;
    if (verified is num) return verified == 1;
    if (verified is String) {
      final value = verified.toLowerCase();
      return value == 'true' || value == '1' || value == 'verified';
    }
    return false;
  }

  Widget _emailVerifiedChip() {
    final verified = _isEmailVerified();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: verified ? AppColors.blue.shade50 : AppColors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        verified ? 'Email verified' : 'Email not verified',
        style: TextStyle(
          color: verified ? AppColors.blue.shade800 : AppColors.orange.shade800,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _companyAvatar(String name) {
    final logoUrl =
        (company['logo'] ?? company['companyLogo'] ?? company['logoUrl'] ?? '')
            .toString();
    final isNetworkImage =
        logoUrl.isNotEmpty &&
        (logoUrl.startsWith('http://') || logoUrl.startsWith('https://'));

    return CircleAvatar(
      radius: 28,
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.16),
      foregroundImage: isNetworkImage ? NetworkImage(logoUrl) : null,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'C',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  String _getCreatedAt() {
    final createdAt = company['createdAt'] ?? company['created_at'];
    if (createdAt == null) return 'Not available';
    return createdAt.toString();
  }

  List<String> _documentUrls() {
    final documents =
        company['documents'] ?? company['document'] ?? company['docs'];
    if (documents == null) return [];

    if (documents is String) {
      return [documents];
    }

    if (documents is List) {
      return documents
          .map((item) {
            if (item is String) return item;
            if (item is Map) {
              return item['url']?.toString() ?? item['path']?.toString() ?? '';
            }
            return item?.toString() ?? '';
          })
          .where((url) => url.isNotEmpty)
          .toList();
    }

    if (documents is Map) {
      final url = documents['url'] ?? documents['path'];
      return url != null ? [url.toString()] : [];
    }

    return [];
  }

  Widget _buildDocumentSection(List<String> urls) {
    if (urls.isEmpty) {
      return Text(
        'No documents available.',
        style: TextStyle(color: AppColors.grey.shade700),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: urls.map((url) => _buildDocumentTile(url)).toList(),
    );
  }

  Widget _buildDocumentTile(String url) {
    final isNetworkImage =
        url.startsWith('http://') || url.startsWith('https://');
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.grey.shade100,
        border: Border.all(color: AppColors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: isNetworkImage
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, color: AppColors.errorColor),
                ),
              )
            : Center(
                child: Text(
                  'Document',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey.shade700),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _value('name');
    final email = _value('email');
    final domain = _value('domain');
    final location = _value('location');
    final ownerName = _value('ownerName');
    final ownerEmail = _value('ownerEmail');
    final id = _value('id');
    final status = _statusText();

    final createdAt = _getCreatedAt();
    final documentUrls = _documentUrls();

    return Scaffold(
      appBar: AppBar(title: const Text('Company Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _companyAvatar(name),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔹 NAME + STATUS IN SAME ROW
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _emailVerifiedChip(), // ✅ right side
                                ],
                              ),

                              const SizedBox(height: 6),

                              // 🔹 EMAIL BELOW
                              Text(
                                email,
                                style: TextStyle(
                                  color: AppColors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _statusWidget(status),

                        Chip(
                          backgroundColor: AppColors.blue.shade50,
                          label: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Text(
                              'ID: $id',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Company Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    _infoRow('Domain', domain),
                    _infoRow('Location', location),
                    _infoRow('Owner Name', ownerName),
                    _infoRow('Owner Email', ownerEmail),
                    const SizedBox(height: 10),
                    const Text(
                      'More Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    _infoRow('Created At', createdAt),
                    const SizedBox(height: 14),
                    const Text(
                      'Documents',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildDocumentSection(documentUrls),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final active = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.green.shade100 : AppColors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: active ? AppColors.green.shade800 : AppColors.red.shade800,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
