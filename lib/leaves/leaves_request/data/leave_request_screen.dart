import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/core/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

// Update these paths to match your exact directory structures
import '../../../core/app_constants/app_color.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/top_message.dart';
import '../../leave_types/data/leave_type_modal.dart';
import '../bloc/leave_request_bloc.dart';
import '../bloc/leave_request_event.dart';
import '../bloc/leave_request_state.dart';
import 'leave_request_modal.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  List<LeaveTypeModel> _apiLeaveTypes = [];
  String? _selectedLeaveTypeId;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<LeaveBloc>().add(FetchLeaveTypesEvent());


  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary100,
              onPrimary: Colors.white,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
            _toDate = null;
          }
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _submitApplication() {
    if (!_formKey.currentState!.validate()) return;
    if (_fromDate == null || _toDate == null) {
      TopMessage.show(
        context,
        'Please select both date parameters.',
        color: AppColors.error,
      );
      return;
    }

    final request = ApplyLeaveRequest(
      leaveTypeId: _selectedLeaveTypeId!,
      fromDate: '${DateFormat('yyyy-MM-dd').format(_fromDate!)}T00:00:00Z',
      toDate: '${DateFormat('yyyy-MM-dd').format(_toDate!)}T00:00:00Z',
      reason: _reasonController.text.trim(),
    );

    context.read<LeaveBloc>().add(SubmitLeaveRequestEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Apply Leave',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary300,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state is LeaveTypesLoadedState) {
            setState(() {
              _apiLeaveTypes = state.leaveTypes;
            });
          }
          if (state is LeaveSuccessState) {
            TopMessage.show(context, "Leave application submitted successfully.", color: AppColors.success);
            Navigator.pop(context);
          } else if (state is LeaveFailureState) {
            TopMessage.show(context, "Failed to submit leave application.", color: AppColors.error);
          }
        },
        builder: (context, state) {
          
          // Show fullscreen spinner while fetching dropdown options from API
          if (state is LeaveTypesLoadingState && _apiLeaveTypes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary100),
            );
          }

          // Error handling view if API categories fail to download
          if (state is LeaveTypesErrorState && _apiLeaveTypes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<LeaveBloc>().add(FetchLeaveTypesEvent()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary100,
                    ),
                    child: const Text(
                      'Retry Loading',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Dynamic Dropdown Population
                  DropdownButtonFormField<String>(
                    value: _selectedLeaveTypeId,
                    decoration: InputDecoration(
                      labelText: 'Leave Type',
                      labelStyle: const TextStyle(color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.primary100,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _apiLeaveTypes.map((LeaveTypeModel type) {
                      return DropdownMenuItem<String>(
                        value: type.id,
                        child: Text(type.name),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedLeaveTypeId = val),
                    validator: (val) =>
                        val == null ? 'Selection required' : null,
                  ),
                  const SizedBox(height: 20),

                  // 2. Date Input Selection Blocks
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDate(context, true),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'From Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _fromDate != null
                                  ? DateFormat('yyyy-MM-dd').format(_fromDate!)
                                  : 'Select Date',
                              style: TextStyle(
                                color: _fromDate != null
                                    ? AppColors.black87
                                    : AppColors.black26,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _fromDate != null
                              ? _pickDate(context, false)
                              : null,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'To Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabled: _fromDate != null,
                            ),
                            child: Text(
                              _toDate != null
                                  ? DateFormat('yyyy-MM-dd').format(_toDate!)
                                  : 'Select Date',
                              style: TextStyle(
                                color: _toDate != null
                                    ? AppColors.black87
                                    : (_fromDate != null
                                          ? AppColors.black54
                                          : AppColors.black26),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 3. Justification text box block
                  CustomTextField(
                    controller: _reasonController,
                    maxLines: 4,

                    label: 'Reason',

                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'Reason required'
                        : null,
                  ),
                  const SizedBox(height: 32),

                  // 4. Form Action Submission Tracker
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: AppGradientButton(
                      onPressed: (state is LeaveSubmittingState)
                          ? null
                          : _submitApplication,

                      text: 'APPLY REQUEST',
                      isLoading: state is LeaveSubmittingState,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
