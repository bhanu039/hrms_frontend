import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/emp_acceptence_bloc.dart';
import '../bloc/emp_acceptence_event.dart';
import '../bloc/emp_acceptence_state.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class OnboardingReviewScreen extends StatelessWidget {
  const OnboardingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textDark,
        title: const Text(
          'Review Profile Details',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<OnboardingReviewBloc, OnboardingReviewState>(
        builder: (context, state) {
          if (state.status == ReviewStatus.loading) {
            return  Center(
              child: CircularProgressIndicator(color: AppColors.info),
            );
          }
          if (state.status == ReviewStatus.failure) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state.employee == null) {
            return const Center(
              child: Text('No employee profile dataset available.'),
            );
          }

          final emp = state.employee!;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= PERSONAL PROFILE BANNER =================
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.info.withOpacity(0.1),
                        backgroundImage:
                            emp.profilePhoto != null &&
                                emp.profilePhoto!.isNotEmpty
                            ? NetworkImage(emp.profilePhoto!)
                            : null,
                        child:
                            emp.profilePhoto == null ||
                                emp.profilePhoto!.isEmpty
                            ? Text(
                                emp.firstName[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${emp.firstName} ${emp.lastName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Code: ${emp.employeeCode}',
                              style:  TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(
                          emp.status,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: emp.status == 'APPROVED'
                            ? AppColors.green
                            : AppColors.orange,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),

                // ================= EMPLOYMENT METADATA =================
                _buildSectionTitle('Employment Parameters'),
                _buildCardGroup([
                  _buildDetailRow(
                    'Designation',
                    emp.designation['title'] ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Department',
                    emp.department['name'] ?? 'N/A',
                  ),
                  _buildDetailRow('Employment Type', emp.employmentType),
                  _buildDetailRow('Work Model', emp.workModel),
                  _buildDetailRow(
                    'Joining Date',
                    emp.joiningDate.split('T')[0],
                  ),
                  _buildDetailRow('BGV Status', emp.bgvStatus),
                ]),

                // ================= SKILLS DATASET =================
                if (emp.skills.isNotEmpty) ...[
                  _buildSectionTitle('Core Skill Domains'),
                  _buildCardGroup(
                    emp.skills.entries
                        .map(
                          (entry) => _buildDetailRow(
                            entry.key,
                            entry.value.toString(),
                          ),
                        )
                        .toList(),
                  ),
                ],

                // ================= BANK ACCOUNT DETAILS =================
                if (emp.bankDetails.isNotEmpty) ...[
                  _buildSectionTitle('Bank Settlement Coordinates'),
                  _buildCardGroup(
                    emp.bankDetails.entries
                        .map(
                          (entry) => _buildDetailRow(
                            entry.key,
                            entry.value.toString(),
                          ),
                        )
                        .toList(),
                  ),
                ],

                // ================= NOMINEE RECORDS =================
                if (emp.nominee.isNotEmpty) ...[
                  _buildSectionTitle('Nominee / Next of Kin'),
                  _buildCardGroup(
                    emp.nominee.entries
                        .map(
                          (entry) => _buildDetailRow(
                            entry.key,
                            entry.value.toString(),
                          ),
                        )
                        .toList(),
                  ),
                ],

                // ================= COMPLIANCE STATUS =================
                if (emp.compliance.isNotEmpty) ...[
                  _buildSectionTitle('Statutory Compliance Framework'),
                  _buildCardGroup(
                    emp.compliance.entries
                        .map(
                          (entry) => _buildDetailRow(
                            entry.key,
                            entry.value.toString(),
                          ),
                        )
                        .toList(),
                  ),
                ],

                // ================= CORE VERIFICATION DOCUMENTS =================
                _buildSectionTitle('Onboarding Document Attachments'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: emp.documents.length,
                  itemBuilder: (context, index) {
                    final doc = emp.documents[index];
                    final bool isApproved = doc.status == 'APPROVED';
                    final bool isRejected = doc.status == 'REJECTED';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isApproved
                              ? AppColors.green.shade100
                              : isRejected
                              ? AppColors.red.shade100
                              : AppColors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.description_rounded,
                            color: isApproved
                                ? AppColors.green
                                : isRejected
                                ? AppColors.red
                                : AppColors.grey,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      doc.status,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isApproved
                                            ? AppColors.green
                                            : isRejected
                                            ? AppColors.red
                                            : AppColors.orange,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    // FIX: Takes up all available space to push the next widget to the end
                                    const Spacer(),

                                    GestureDetector(
                                      onTap: () => _openDocumentPreviewModal(
                                        context,
                                        doc.name,
                                        doc.fileUrl,
                                      ),
                                      child: const Icon(
                                        Icons.remove_red_eye_rounded,
                                        size: 20,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          if (!isApproved && !isRejected) ...[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.successColor,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                              ),
                              onPressed: () {
                                context.read<OnboardingReviewBloc>().add(
                                  UpdateDocumentStatusEvent(
                                    docId: doc.id,
                                    status: 'APPROVED',
                                    remarks: 'Looks good',
                                  ),
                                );
                              },
                              child: const Text(
                                'Approve',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.danger,
                                side:  BorderSide(
                                  color: AppColors.danger,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                              ),
                              onPressed: () =>
                                  _showRejectionDialog(context, doc.id),
                              child: const Text(
                                'Reject',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ] else ...[
                            Icon(
                              isApproved
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              color: isApproved ? AppColors.green : AppColors.red,
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 0, 8),
      child: Text(
        title,
        style:  TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.slate700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:  TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style:  TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textDark,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _openDocumentPreviewModal(
    BuildContext context,
    String docName,
    String url,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      docName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Container(
                  color: AppColors.grey.shade50,
                  alignment: Alignment.center,
                  child: url.toLowerCase().contains('.pdf')
                      ?  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf_rounded,
                              size: 64,
                              color: AppColors.redAccent,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "PDF Attachment Loaded Successfully",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.black54,
                              ),
                            ),
                          ],
                        )
                      : Image.network(
                          url,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Text(
                                "Failed to render attachment image preview.",
                              ),
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                              ? child
                              : const CircularProgressIndicator(),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRejectionDialog(BuildContext context, String docId) {
    final TextEditingController remarksController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Reject Document',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: TextField(
            controller: remarksController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter reason for rejection...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: AppColors.white,
              ),
              onPressed: () {
                final remarks = remarksController.text.trim();
                if (remarks.isNotEmpty) {
                  context.read().add(
                    UpdateDocumentStatusEvent(
                      docId: docId,
                      status: 'REJECTED',
                      remarks: remarks,
                    ),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Confirm Reject'),
            ),
          ],
        );
      },
    );
  }
}



