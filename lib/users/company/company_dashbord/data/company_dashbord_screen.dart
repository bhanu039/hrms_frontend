import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/core/widgets/custom_dailogbox.dart';
import 'package:goexperts/core/widgets/top_message.dart';

import '../../../../core/state/auth/auth_bloc.dart';
import '../../Screens/company_menu.dart';
import '../bloc/company_dashbord_bloc.dart';
import '../bloc/company_dashbord_state.dart';
import '../bloc/company_dashbords_event.dart';
import 'company_dashbord_modal.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  late String name;
  bool condition = false;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    name = context.read<AuthBloc>().state.session?.name ?? 'Company';

    context.read<CompanyDashboardBloc>().add(const LoadDashboard());
  }

  Future<void> _refresh() async {
    context.read<CompanyDashboardBloc>().add(const LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        title: const Text(
          "Company Dashboard",
          style: TextStyle(color: AppColors.white),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: const [
          Icon(Icons.notifications, color: AppColors.white),
          SizedBox(width: 12),
        ],
      ),

      drawer: const CompanyDrawer(),
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: BlocBuilder<CompanyDashboardBloc, CompanyDashboardState>(
          builder: (context, state) {
            CompanyDashboardModel? d;

            if (state is CompanyDashboardError) {
              condition = false;
              errorMessage = state.message;
              d = CompanyDashboardModel(
                kpis: null,
                subscription: null,
                // add your other nullable fields here
              );
            }

            if (state is CompanyDashboardLoaded) {
              condition = true;
              d = state.data;
            }

            if (state is CompanyDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: const [
                              AppColors.primary,
                              AppColors.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back,',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                '$name 👋',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // ERROR MESSAGE TOP
                    if (errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.red.shade50,
                          border: Border.all(color: AppColors.red, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: AppColors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: TextStyle(
                                  color: AppColors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(-20 * (1 - value), 0),
                            child: child,
                          ),
                        );
                      },
                      child: GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  200, // 👈 auto number of columns
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio:
                                  2.2, // controls height automatically
                            ),

                        children: [
                          _modernKpiCard(
                            "Total Employees",
                            (d?.kpis?.totalEmployees?.value ?? 0).toString(),
                            d?.kpis?.totalEmployees?.trendDirection ?? "",
                            AppColors.blue,
                          ),
                          _modernKpiCard(
                            "Total Projects",
                            (d?.kpis?.totalProjects?.value ?? 0).toString(),
                            d?.kpis?.totalProjects?.trendDirection ?? "",
                            AppColors.green,
                          ),
                          _modernKpiCard(
                            "Attendance",
                            "${d?.kpis?.attendanceRate?.value ?? 0}%",
                            "up",
                            AppColors.orange,
                          ),
                          _modernKpiCard(
                            "On Leave",
                            (d?.kpis?.onLeaveToday?.value ?? 0).toString(),
                            "",
                            AppColors.red,
                          ),
                          _modernKpiCard(
                            "Payroll Due",
                            d?.kpis?.payrollDue?.formatted ?? "0",
                            "",
                            AppColors.purple,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (d != null) ...[
                      _subscriptionCard(d),

                      const SizedBox(height: 4),

                      _attendanceCard(d),

                      const SizedBox(height: 4),

                      _workModeChart(d),

                      const SizedBox(height: 8),

                      _pendingActions(d),

                      const SizedBox(height: 8),

                      _recentActivity(d),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [AppColors.indigo, AppColors.indigo.shade400],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.indigo.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: FloatingActionButton.extended(
          onPressed: () {
            condition
                ? context.push("/company/empcreate")
                : CustomDialog.show(
                    context: context,
                    title: "Permission",
                    message: errorMessage!,
                    icon: Icons.error,
                    color: AppColors.red,
                  );
          },

          backgroundColor: AppColors.transparent,
          elevation: 0,

          icon: const Icon(Icons.person_add_alt_1, color: AppColors.white),

          label: const Text(
            "Add Employee",
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _baseCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(18),

        // ⭐ modern subtle border
        border: Border.all(color: AppColors.greyLight, width: 1),

        // ⭐ premium soft shadow (modern UI standard)
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: child,
    );
  }

  /// ---------------- KPI CARD ----------------

  Widget _modernKpiCard(String title, String value, String trend, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), AppColors.white],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ================= LEFT ICON =================
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.bar_chart_rounded, color: color, size: 22),
          ),

          const SizedBox(width: 10),

          // ================= TEXT AREA =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black87,
                  ),
                ),
              ],
            ),
          ),

          // ================= TREND =================
          if (trend.isNotEmpty) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                // ⭐ Dynamically colors background based on up/down state
                color: trend == "up"
                    ? AppColors.green.withOpacity(0.12)
                    : trend == "down"
                    ? AppColors.red.withOpacity(0.12)
                    : AppColors.grey.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                // ⭐ Dynamically chooses arrow direction
                trend == "up"
                    ? "↑"
                    : trend == "down"
                    ? "↓"
                    : "•",
                style: TextStyle(
                  // ⭐ Dynamically colors text icon based on up/down state
                  color: trend == "up"
                      ? AppColors.green
                      : trend == "down"
                      ? AppColors.red
                      : AppColors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// ---------------- SUBSCRIPTION ----------------
  Widget _subscriptionCard(CompanyDashboardModel d) {
    return _baseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            d.subscription?.planName ?? "Free Plan",
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (d.subscription?.usagePercentage ?? 0) / 100,
              minHeight: 8,
              backgroundColor: AppColors.surfaceMuted,
              color: AppColors.accentGreen,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Valid for ${d.subscription?.daysRemaining ?? 0} days",
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  /// ---------------- ATTENDANCE ----------------
  Widget _attendanceCard(CompanyDashboardModel d) {
    final a = d.todaysAttendance?.breakdown;

    return _baseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Attendance",
            style: TextStyle(color: AppColors.textDark, fontSize: 16),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _attBox("Present", a?.present ?? 0, AppColors.green),
              _attBox("Absent", a?.absent ?? 0, AppColors.red),
              _attBox("Leave", a?.onLeave ?? 0, AppColors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attBox(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: AppColors.textMuted)),
      ],
    );
  }

  Widget _workModeChart(CompanyDashboardModel d) {
    final work = d.charts?.workModelSplit;

    final wfo = (work?.wfo ?? 40);
    final wfh = (work?.wfh ?? 35);
    final hybrid = (work?.hybrid ?? 25);

    // ensure total = 100 visually safe
    final total = (wfo + wfh + hybrid).toDouble();

    double percent(int value) {
      return total == 0 ? 0 : (value / total);
    }

    return _baseCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.lightBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Work Mode Distribution",
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _workBar("WFO", wfo, percent(wfo), AppColors.blue),
            const SizedBox(height: 12),

            _workBar("WFH", wfh, percent(wfh), AppColors.green),
            const SizedBox(height: 12),

            _workBar("Hybrid", hybrid, percent(hybrid), AppColors.orange),
          ],
        ),
      ),
    );
  }

  Widget _workBar(String label, int value, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: AppColors.textSecondaryColor)),
            Text(
              "${value.toString()}%",
              style: TextStyle(color: AppColors.textDark),
            ),
          ],
        ),

        const SizedBox(height: 6),

        ClipRRect(
          borderRadius: BorderRadius.circular(20), // 👈 fully rounded
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 10,
            backgroundColor: AppColors.surfaceMuted,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _pendingActions(CompanyDashboardModel d) {
    return _baseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pending Actions",
            style: TextStyle(color: AppColors.textDark, fontSize: 16),
          ),

          const SizedBox(height: 10),

          ...(d.pendingActions?.items ?? []).map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.label ?? "",
                    style: TextStyle(color: AppColors.textSecondaryColor),
                  ),
                  Text(
                    "${e.count ?? 0}",
                    style: TextStyle(color: AppColors.textDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentActivity(CompanyDashboardModel d) {
    return _baseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Activity",
            style: TextStyle(color: AppColors.textDark, fontSize: 16),
          ),

          const SizedBox(height: 10),

          ...(d.recentActivity ?? []).map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title ?? "",
                    style: TextStyle(color: AppColors.textSecondaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.type ?? "",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
