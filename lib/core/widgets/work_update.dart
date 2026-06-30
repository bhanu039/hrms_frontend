import 'package:flutter/material.dart';

import 'custom_text_field.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class WorkSubmissionScreen extends StatefulWidget {
  const WorkSubmissionScreen({super.key});

  @override
  State<WorkSubmissionScreen> createState() => _WorkSubmissionScreenState();
}

class _WorkSubmissionScreenState extends State<WorkSubmissionScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void submitWork() {
    final title = titleController.text.trim();
    final desc = descriptionController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }
    // 👉 Send data back to previous page
    Navigator.pop(context, {"title": title, "description": desc});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// 🔥 Bottom Submit Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: submitWork,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.indigoBrand,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Submit Work",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 20),

            Padding(padding: const EdgeInsets.all(16), child: _buildFormCard()),
          ],
        ),
      ),
    );
  }

  /// 🔷 Header Section
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.warningColor, AppColors.pastelOrange],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.assignment_rounded, color: AppColors.white, size: 42),
          SizedBox(height: 12),
          Text(
            "Work Submission",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Submit your task details below",
            style: TextStyle(color: AppColors.textSecondaryColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// 🧾 Form Card
  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: titleController,
            label: "Work Title",
            prefixIcon: const Icon(Icons.title),
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: descriptionController,
            label: "Description",
            prefixIcon: const Icon(Icons.description),
            maxLines: 6,
          ),
        ],
      ),
    );
  }
}
