import 'package:flutter/material.dart';
import '../data/company_profile_modal.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyDocumentsWidget extends StatelessWidget {
  final CompanyProfileData profile;
  final Function() onUploadDocument;

  const CompanyDocumentsWidget({
    Key? key,
    required this.profile,
    required this.onUploadDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final documents = profile.documents ?? [];

    return Stack(
      children: [
        if (documents.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.file_present,
                  size: 64,
                  color: AppColors.grey.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                 Text(
                  'No documents yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                 Text(
                  'Upload documents to complete your profile',
                  style: TextStyle(fontSize: 12, color: AppColors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                return _buildDocumentCard(context, doc);
              },
            ),
          ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: AppColors.brandBlue,
            onPressed: onUploadDocument,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentCard(BuildContext context, CompanyDocument document) {
    final fileExtension =
        document.name?.split('.').last.toUpperCase() ?? 'FILE';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side:  BorderSide(color: AppColors.amberDarker, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.brandBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      fileExtension.substring(0, 1),
                      style:  TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.name ?? 'Unknown',
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$fileExtension • ${_getFileSize(document)}',
                        style:  TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(document.status),
              ],
            ),
            const SizedBox(height: 12),
            if (document.uploadedAt != null)
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'Uploaded: ${_formatDate(document.uploadedAt!)}',
                    style:  TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                ],
              ),
            if (document.remarks != null && document.remarks!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.comment, size: 14, color: AppColors.orange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        document.remarks!,
                        style:   TextStyle(
                          fontSize: 12,
                          color: AppColors.orange,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (document.fileUrl != null)
                  TextButton.icon(
                    onPressed: () =>
                        _downloadDocument(context, document.fileUrl!),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download'),
                  ),
                TextButton.icon(
                  onPressed: () => _showDeleteDialog(context, document),
                  icon:  Icon(Icons.delete, size: 16, color: AppColors.red),
                  label:  Text(
                    'Delete',
                    style: TextStyle(color: AppColors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    final isVerified = status?.toLowerCase() == 'verified';
    final isPending = status?.toLowerCase() == 'pending';
    final isRejected = status?.toLowerCase() == 'rejected';

    Color bgColor;
    Color textColor;
    IconData icon;

    if (isVerified) {
      bgColor = AppColors.green.withOpacity(0.1);
      textColor = AppColors.green;
      icon = Icons.check_circle;
    } else if (isPending) {
      bgColor = AppColors.blue.withOpacity(0.1);
      textColor = AppColors.blue;
      icon = Icons.schedule;
    } else if (isRejected) {
      bgColor = AppColors.red.withOpacity(0.1);
      textColor = AppColors.red;
      icon = Icons.cancel;
    } else {
      bgColor = AppColors.grey.withOpacity(0.1);
      textColor = AppColors.grey;
      icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            status ?? 'Unknown',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getFileSize(CompanyDocument document) {
    // This is a placeholder. In real app, you'd get actual file size
    return 'Unknown';
  }

  void _downloadDocument(BuildContext context, String url) {
    // Implement download logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Download started')));
  }

  void _showDeleteDialog(BuildContext context, CompanyDocument document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete "${document.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement delete logic
            },
            child:  Text('Delete', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }
}



