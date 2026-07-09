import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/core/widgets/custom_dailogbox.dart';
import 'package:goexperts/users/hr/screens/hr_menu.dart';
import '../core/state/auth/auth_bloc.dart';
import '../core/widgets/dropdown_list.dart';
import '../core/widgets/top_message.dart';
import '../users/company/Screens/company_menu.dart';
import 'employee_list_bloc.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class EmployeeListScreen extends StatefulWidget {
  final String role;

  const EmployeeListScreen({super.key, required this.role});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String mainrole =
        context.read<AuthBloc>().state.session?.role ??
        ''; // Capture the role parameter for use in the BlocProvider

    String dataType = 'ACTIVE'; // Default value for dataType
    // 1. Locally inject the BLoC provider and immediately fire the initial fetch request
    return BlocProvider(
      create: (context) => EmployeeListBloc()
        ..add(FetchEmployeesEvent(role: widget.role, dataType: dataType ?? '')),
      child: Scaffold(
        backgroundColor: AppColors.screenBg,
        drawer: mainrole == 'HR' ? HrDrawer() : CompanyDrawer(),
        appBar: AppBar(title: Text(" Employees List"), centerTitle: true),

        // 2. Wrap body inside a Listener to handle one-time popups (Toasts/Dialogs) smoothly
        body: BlocListener<EmployeeListBloc, EmployeeListState>(
          listenWhen: (previous, current) => current.alertMessage != null,
          listener: (context, state) {
            CustomDialog.show(
              context: context,
              title: state.isActionSuccess ? "Success" : "Error",
              message: state.alertMessage!,
              icon: state.isActionSuccess
                  ? Icons.join_right_outlined
                  : Icons.error,
              color: state.isActionSuccess
                  ? AppColors.successColor
                  : AppColors.red,
            );
          },
          child: BlocBuilder<EmployeeListBloc, EmployeeListState>(
            builder: (context, state) {
              // Handle main workflow content layers
              if (state.status == EmployeeListStatus.loading &&
                  !state.isActionLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.info),
                );
              }
              if (state.status == EmployeeListStatus.failure) {
                return const Center(
                  child: Text("Failed to load employee records registry."),
                );
              }

              // Stack allows drawing a global translucent blocker screen if an operation is background executing
              return RefreshIndicator(
                color: AppColors.blue,
                backgroundColor: AppColors.white,
                onRefresh: () async {
                  dataType =
                      "ACTIVE"; // Preserve the current dataType for refresh
                  // CRITICAL: We use innerContext here so it finds the Bloc successfully
                  context.read<EmployeeListBloc>().add(
                    FetchEmployeesEvent(role: widget.role, dataType: "ACTIVE"),
                  );
                  await Future.delayed(const Duration(milliseconds: 800));
                },
                // 4. Ensure an empty list state remains scrollable so pull-to-refresh works
                child: Container(
                  decoration: BoxDecoration(color: AppColors.screenBg),

                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Employees: ${state.employees.length}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              SizedBox(width: 5),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    16,
                                    8,
                                  ),
                                  child: TextField(
                                    onChanged: (query) {
                                      // Example: context.read<EmployeeListBloc>().add(SearchEmployeeEvent(query));
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search employees...',
                                      prefixIcon: const Icon(Icons.search),
                                      filled: true,
                                      fillColor: AppColors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.filter_alt),
                                onSelected: (value) {
                                  context.read<EmployeeListBloc>().add(
                                    FetchEmployeesEvent(
                                      role: widget.role,
                                      dataType: value,
                                    ),
                                  );
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: "ACTIVE",
                                    child: Text("Active"),
                                  ),
                                  PopupMenuItem(
                                    value: "PENDING",
                                    child: Text("Pending"),
                                  ),
                                  PopupMenuItem(
                                    value: "DELETED",
                                    child: Text("Deleted"),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Expanded(
                            child: state.employees.isEmpty
                                ? ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.3,
                                      ),
                                      Center(
                                        child: Text(
                                          "No Employees Found",
                                          style: TextStyle(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(5),
                                    itemCount: state.employees.length,
                                    itemBuilder: (context, index) {
                                      final emp = state.employees[index];

                                      return EmployeeCard(
                                        emp: emp,
                                        onTap: () {
                                          context.push(
                                            '/onboarding/review/${emp.id}',
                                          );
                                        },
                                        onDelete: () {
                                          context.read<EmployeeListBloc>().add(
                                            DeleteEmployeeEvent(emp.id),
                                          );
                                        },
                                        onStatusTap: () {
                                          emp.status == "ACTIVE"
                                              ? TopMessage.show(
                                                  context,
                                                  "Employee is already active.",
                                                  color: AppColors.green,
                                                )
                                              : context
                                                    .read<EmployeeListBloc>()
                                                    .add(
                                                      ActivateEmployeeEvent(
                                                        emp.id,
                                                      ),
                                                    );
                                        },
                                      );
                                    },
                                  ),
                          ),

                          // Background operation execution layout barrier blocker overlay
                          if (state.isActionLoading)
                            Container(
                              color: AppColors.black26,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final dynamic emp;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onStatusTap;

  const EmployeeCard({
    super.key,
    required this.emp,
    required this.onDelete,
    required this.onTap,
    required this.onStatusTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.surfaceElevated,
              border: Border.all(
                color: AppColors.grey.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowSoft,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Automatically wraps tightly around rows
                children: [
                  /// TOP ROW
                  Row(
                    children: [
                      Hero(
                        tag: emp.id ?? UniqueKey().toString(),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 34,
                            backgroundColor: AppColors.blueTint,
                            child: ClipOval(
                              child:
                                  (emp.profilePhoto != null &&
                                      emp.profilePhoto
                                          .toString()
                                          .trim()
                                          .isNotEmpty)
                                  ? Image.network(
                                      emp.profilePhoto.toString(),
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return _initialWidget();
                                          },
                                    )
                                  : _initialWidget(),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${emp.firstName ?? ""} ${emp.lastName ?? ""}"
                                      .trim()
                                      .isEmpty
                                  ? "Unknown Employee"
                                  : "${emp.firstName ?? ""} ${emp.lastName ?? ""}",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                emp.employeeCode ?? "N/A",
                                style: TextStyle(
                                  color: AppColors.textSecondaryColor,
                                ),
                              ),
                            ),

                            const SizedBox(height: 2),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blueTint,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                emp.designation.title ?? "--",
                                style: TextStyle(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.dangerTint,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: onDelete,
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  /// BOTTOM ROW
                  Row(
                    children: [
                      Expanded(
                        
                        child: InkWell(
                          onTap: onStatusTap,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: emp.status == "ACTIVE"
                                  ? AppColors.successTint
                                  : AppColors.warningTint,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: AppColors.textSecondaryColor,
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "STATUS",
                                      style: TextStyle(
                                        color: AppColors.textSecondaryColor,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      emp.status == "ACTIVE"
                                          ? "ACTIVE"
                                          : "PENDING",
                                      style: TextStyle(
                                        color: emp.status == "ACTIVE"
                                            ? AppColors.successColor
                                            : AppColors.amberDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.blueTint,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.verified_user, color: AppColors.info),
                              const SizedBox(width: 5),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "OnboardingCompleted",
                                    style: TextStyle(
                                      color: AppColors.textSecondaryColor,
                                      fontSize: 11,
                                    ),
                                  ),

                                  Text(
                                    emp.bgvStatus ? "Yes" : "No",
                                    style: TextStyle(
                                      color: AppColors.info,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _initialWidget() {
    String initial = "?";

    if (emp.firstName != null && emp.firstName.toString().trim().isNotEmpty) {
      initial = emp.firstName.toString()[0].toUpperCase();
    }

    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.info,
        ),
      ),
    );
  }
}
