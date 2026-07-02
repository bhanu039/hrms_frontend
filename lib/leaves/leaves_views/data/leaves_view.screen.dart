import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_constants/app_color.dart';
import '../../../core/widgets/actions_cards.dart';
import '../bloc/leaves_view_bloc.dart';
import '../bloc/leaves_view_event.dart';
import '../bloc/leaves_view_state.dart';

class LeavesViewScreen extends StatefulWidget {
  final String listType; // Optional parameter to specify the type of leave list to display
  const LeavesViewScreen({super.key,required this.listType});

  @override
  State<LeavesViewScreen> createState() => _LeavesViewScreenState();
}

class _LeavesViewScreenState extends State<LeavesViewScreen> {
   String? datatype ; // Default to showing all leaves if no type is specified
  @override
  void initState() {
    super.initState();
    datatype = widget.listType ;

    context.read<LeavesViewBloc>().add(GetLeaves(datatype));
  }

  Future<void> _refresh() async {
    context.read<LeavesViewBloc>().add(RefreshLeaves(datatype));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: datatype == "me" ? const Text("My Leaves") : const Text("Employee Leaves"), centerTitle: true),
      body: BlocConsumer<LeavesViewBloc, LeavesViewState>(
        listener: (context, state) {
          if (state.successMessage != null &&
              state.successMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
          }

          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == LeaveStatus.loading && state.leaves.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == LeaveStatus.failure && state.leaves.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 70, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? "Something went wrong"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LeavesViewBloc>().add(GetLeaves());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state.leaves.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 150),
                  Icon(
                    Icons.beach_access_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      "No Leave Requests",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.leaves.length,
              itemBuilder: (context, index) {
                final leave = state.leaves[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: UniversalActionCard(
                    datatype: datatype,
                   
                    imageUrl: leave.employee?.profileImageUrl??null, // Assuming no image URL is provided for leaves
                    
                    employeeName: "${leave.employee?.firstName??null} ${leave.employee?.lastName}",
                    title: leave.leaveType.name,

                    description: "Reason: ${leave.reason}",

                    status: leave.status,

                    statusColor: leave.status == "Approved"
                        ? AppColors.success
                        : leave.status == "Rejected"
                            ? AppColors.error
                            : AppColors.warning,

                    details:  [
                      CardDetail(
                        icon: Icons.calendar_today,
                        label: "${leave.fromDate} - ${leave.toDate}",
                      ),
                      if (datatype != "me") ...[

                      

                      CardDetail(icon: Icons.person_2_rounded, label: leave.employee?.id ?? "N/A"),

                      CardDetail(icon: Icons.mail, label: leave.user?.mail ?? "N/A"),
                      ],
                    ],

                    actions: [
                      if (datatype != "me") ...[
                        CardAction(
                          icon: Icons.check_circle_outline,
                          tooltip: "Approve",
                          color: Colors.green,
                          onPressed: () {
                            context.read<LeavesViewBloc>().add(
                                ApproveLeave(datatype!, leave.id),
                              );
                        },
                      ),

                      CardAction(
                        icon: Icons.cancel_outlined,
                        tooltip: "Reject",
                        color: Colors.red,
                        onPressed: () {
                          context.read<LeavesViewBloc>().add(
                                RejectLeave(datatype!, leave.id),
                              );
                        },
                      ),

                      
                    ]else if(leave.status == "Pending")...[
                       
                      CardAction(
                          icon: Icons.cancel_outlined,
                          tooltip: "cancel",
                          onPressed: () {
                            context.read<LeavesViewBloc>().add(
                                  CancelLeave(datatype!, leave.id),
                                );
                          },
                        ),
                      ],
                    
                    ]
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
