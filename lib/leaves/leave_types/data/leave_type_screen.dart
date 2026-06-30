import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_constants/app_color.dart';
import '../bloc/leave_type_bloc.dart';
import '../bloc/leave_type_event.dart';
import '../bloc/leave_type_state.dart';
import 'leave_type_modal.dart';
import 'leave_type_repo.dart';

class LeaveTypesScreen extends StatelessWidget {
  const LeaveTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LeaveTypeBloc(repository: LeaveTypeRepository())
            ..add(FetchLeaveTypesEvent()),
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            backgroundColor: AppColors.scaffold,
            appBar: AppBar(
              title: const Text(
                "Leave Type Configurations",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppColors.primary,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: BlocListener<LeaveTypeBloc, LeaveTypeState>(
              listenWhen: (prev, curr) => curr.alertMessage != null,
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.alertMessage!),
                    backgroundColor: state.isActionSuccess
                        ? Colors.green
                        : AppColors.secondary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: BlocBuilder<LeaveTypeBloc, LeaveTypeState>(
                builder: (context, state) {
                  if (state.status == LeaveTypeStatus.loading &&
                      !state.isActionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  if (state.status == LeaveTypeStatus.failure &&
                      state.leaveTypes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Failed to parse infrastructure pipeline logs.",
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: () => innerContext
                                .read<LeaveTypeBloc>()
                                .add(FetchLeaveTypesEvent()),
                            child: const Text(
                              "Retry",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async {
                          innerContext.read<LeaveTypeBloc>().add(
                            FetchLeaveTypesEvent(),
                          );
                          await Future.delayed(
                            const Duration(milliseconds: 400),
                          );
                        },
                        child: state.leaveTypes.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.3,
                                  ),
                                  const Center(
                                    child: Text(
                                      "No Leave Types Registered Currently",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                itemCount: state.leaveTypes.length,
                                itemBuilder: (context, index) {
                                  final type = state.leaveTypes[index];
                                  return Card(
                                    color: AppColors.card,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 6,
                                          ),
                                      leading: CircleAvatar(
                                        backgroundColor: AppColors.primary50,
                                        child: const Icon(
                                          Icons.date_range,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      title: Text(
                                        type.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Max Allocation: ${type.maxDays} Days",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              color: AppColors.primary,
                                            ),
                                            onPressed: () => _showFormDialog(
                                              innerContext,
                                              leaveType: type,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: AppColors.secondary,
                                            ),
                                            onPressed: () =>
                                                _showDeleteConfirmation(
                                                  innerContext,
                                                  type,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),

                      if (state.isActionLoading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black26,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, size: 28),
              onPressed: () => _showFormDialog(innerContext),
            ),
          );
        },
      ),
    );
  }

  // Unified Form Overlay Dialog for handling both CREATE and UPDATE modes seamlessly
  void _showFormDialog(BuildContext blocContext, {LeaveTypeModel? leaveType}) {
    final isEditMode = leaveType != null;
    final nameController = TextEditingController(text: leaveType?.name);
    final daysController = TextEditingController(
      text: leaveType?.maxDays.toString(),
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: blocContext,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.dialog,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            isEditMode ? "Modify Leave Type" : "Add Custom Leave Type",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 18,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Leave Name",
                    labelStyle: const TextStyle(color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.field,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? "Please type field context name value"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: daysController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Max Days Allocation",
                    labelStyle: const TextStyle(color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.field,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) => (int.tryParse(v ?? '') == null)
                      ? "Type valid capacity number"
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final int days = int.parse(daysController.text.trim());
                  final String name = nameController.text.trim();
                  if (isEditMode) {
                    blocContext.read().add(
                      UpdateLeaveTypeEvent(
                        id: leaveType.id,
                        name: name,
                        maxDays: days,
                      ),
                    );
                  } else {
                    blocContext.read().add(
                      CreateLeaveTypeEvent(name: name, maxDays: days),
                    );
                  }
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(
                isEditMode ? "Save" : "Submit",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Security confirmation overlay for delete operations
  void _showDeleteConfirmation(
    BuildContext blocContext,
    LeaveTypeModel leaveType,
  ) {
    showDialog(
      context: blocContext,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.dialog,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.secondary),
              SizedBox(width: 8),
              Text(
                "Delete Leave Type",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you completely sure you want to remove \"${leaveType.name}\" from the backend server registry? This action cannot be reversed.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                blocContext.read().add(DeleteLeaveTypeEvent(id: leaveType.id));
                Navigator.pop(dialogContext);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
