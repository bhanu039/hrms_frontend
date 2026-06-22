import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/core/widgets/custom_dailogbox.dart';
import 'package:goexperts/core/widgets/top_message.dart';

import '../../../core/state/auth/auth_bloc.dart';
import '../../Screens/company_menu.dart';
import '../bloc/company_dashbord_bloc.dart';
import '../bloc/company_dashbord_state.dart';
import '../bloc/company_dashbords_event.dart';
import 'company_dashbord_modal.dart';

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
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.orange),
            onPressed: () {
              condition
                  ? Scaffold.of(context).openDrawer()
                  : CustomDialog.show(
                      context: context,
                      title: "Permission",
                      message:
                          " ${errorMessage!} \n If You Want Logout Go TO Profile",
                      icon: Icons.error,
                      color: Colors.red,
                    );
            },
          ),
        ),
        title: const Text(
          "Company Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 187, 203, 224),
                Color.fromARGB(255, 69, 76, 87),
                Color.fromARGB(255, 187, 203, 224),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: const [
          Icon(Icons.notifications, color: Colors.white),
          SizedBox(width: 12),
        ],
      ),

      drawer: const CompanyDrawer(),
      backgroundColor: const Color.fromARGB(255, 252, 253, 255),
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
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 153, 184, 236),
                              Color.fromARGB(255, 187, 203, 224),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome Back,',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
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
                                  color: Colors.white,
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
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
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
                            Colors.blue,
                          ),
                          _modernKpiCard(
                            "Total Projects",
                            (d?.kpis?.totalProjects?.value ?? 0).toString(),
                            d?.kpis?.totalProjects?.trendDirection ?? "",
                            Colors.green,
                          ),
                          _modernKpiCard(
                            "Attendance",
                            "${d?.kpis?.attendanceRate?.value ?? 0}%",
                            "up",
                            Colors.orange,
                          ),
                          _modernKpiCard(
                            "On Leave",
                            (d?.kpis?.onLeaveToday?.value ?? 0).toString(),
                            "",
                            Colors.red,
                          ),
                          _modernKpiCard(
                            "Payroll Due",
                            d?.kpis?.payrollDue?.formatted ?? "0",
                            "",
                            Colors.purple,
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
            colors: [Colors.indigo, Colors.indigo.shade400],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3),
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
                    color: Colors.red,
                  );
          },

          backgroundColor: Colors.transparent,
          elevation: 0,

          icon: const Icon(Icons.person_add_alt_1, color: Colors.white),

          label: const Text(
            "Add Employee",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        // ⭐ modern subtle border
        border: Border.all(color: const Color(0xFFEDEDED), width: 1),

        // ⭐ premium soft shadow (modern UI standard)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
          colors: [color.withOpacity(0.15), Colors.white],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
                    ? Colors.green.withOpacity(0.12)
                    : trend == "down"
                    ? Colors.red.withOpacity(0.12)
                    : Colors.grey.withOpacity(0.12),
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
                      ? Colors.green
                      : trend == "down"
                      ? Colors.red
                      : Colors.grey,
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
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
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
              backgroundColor: const Color.fromARGB(31, 0, 0, 0),
              color: Colors.greenAccent,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Valid for ${d.subscription?.daysRemaining ?? 0} days",
            style: const TextStyle(color: Color.fromARGB(153, 0, 0, 0)),
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
          const Text(
            "Today's Attendance",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _attBox("Present", a?.present ?? 0, Colors.green),
              _attBox("Absent", a?.absent ?? 0, Colors.red),
              _attBox("Leave", a?.onLeave ?? 0, Colors.orange),
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
        Text(
          label,
          style: const TextStyle(color: Color.fromARGB(153, 7, 7, 7)),
        ),
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
          color: const Color.fromARGB(255, 246, 236, 236),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Work Mode Distribution",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _workBar("WFO", wfo, percent(wfo), Colors.blue),
            const SizedBox(height: 12),

            _workBar("WFH", wfh, percent(wfh), Colors.green),
            const SizedBox(height: 12),

            _workBar("Hybrid", hybrid, percent(hybrid), Colors.orange),
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
            Text(
              label,
              style: const TextStyle(color: Color.fromARGB(179, 107, 0, 0)),
            ),
            Text(
              "${value.toString()}%",
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),

        const SizedBox(height: 6),

        ClipRRect(
          borderRadius: BorderRadius.circular(20), // 👈 fully rounded
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 10,
            backgroundColor: const Color.fromARGB(26, 72, 59, 59),
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
          const Text(
            "Pending Actions",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
          ),

          const SizedBox(height: 10),

          ...(d.pendingActions?.items ?? []).map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.label ?? "",
                    style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                  ),
                  Text(
                    "${e.count ?? 0}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 45, 0, 0),
                    ),
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
          const Text(
            "Recent Activity",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
          ),

          const SizedBox(height: 10),

          ...(d.recentActivity ?? []).map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title ?? "",
                    style: const TextStyle(
                      color: Color.fromARGB(179, 14, 7, 7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.type ?? "",
                    style: const TextStyle(color: Colors.white38),
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
