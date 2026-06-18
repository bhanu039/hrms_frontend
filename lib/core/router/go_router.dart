import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/company/Screens/companyShell_tabs.dart';
import 'package:goexperts/company/company_fullReg/screens/full_com_Reg_screen.dart';
import 'package:goexperts/core/invite_emp.dart/bloc/invite_emp_bloc.dart';
import 'package:goexperts/core/invite_emp.dart/modal/invite_emp_repo.dart';
import 'package:goexperts/core/state/auth/auth_bloc.dart';

import 'package:flutter/material.dart';
import 'package:goexperts/core/widgets/face_detact.dart';
import 'package:goexperts/core/set_password_screen.dart';

import '../../admin/Screens/company_view_screen.dart';
import '../../admin/company_reg/bloc/company_reg_bloc.dart';
import '../../admin/company_reg/bloc/company_reg_event.dart';
import '../../admin/company_reg/data/company_reg_repository.dart';
import '../../admin/company_reg/screens/company_reg_ui.dart';
import '../../company/Screens/subscription_plans.dart';
import '../../company/company_dashbord/bloc/company_dashbord_bloc.dart';
import '../../company/company_dashbord/data/company_dashbord_repo.dart';
import '../../company/company_dashbord/data/company_dashbord_screen.dart';
import '../../company/company_fullReg/bloc/full_Reg_bloc.dart';
import '../../company/company_fullReg/data/repository/repository_empFullreg.dart';
import '../../employe/Screens/empShell_tabs.dart';
import '../../employe/emp_full_reg/bloc/emp_full_bloc.dart';
import '../../hr/attendance/bloc/attendance_bloc.dart';
import '../../hr/attendance/bloc/attendance_event.dart';
import '../../hr/attendance/screen/emps_attendence.dart';
import '../../hr/hr_dashbord/bloc/hr_dashbord_bloc.dart';
import '../../hr/hr_dashbord/data/hr_dashbord_repo.dart';
import '../../hr/hr_dashbord/data/hr_dashbord_screenui.dart';
import '../../hr/screens/hrshell_tabs.dart';
import '../../login_screen.dart';
import '../../splash_screen.dart';

// Admin
import '../../admin/Screens/admin_prifile.dart';
import '../../admin/Screens/companys_list.dart';
import '../../admin/Screens/dashboard_screen.dart';
import '../../admin/Screens/adminSell_tabs.dart';
import '../../admin/Screens/deleted_companys_list.dart';
import '../../admin/Screens/subscription_plans.dart';

//company
import '../../company/Screens/company_profile_screen.dart';
import '../../company/Screens/employee_screen.dart';

// HR
import '../../hr/screens/hr_Profile.dart';

//employee

import '../../employe/Screens/employee_dashbord.dart';
import '../../employe/Screens/project_screen.dart';
import '../../employe/emp_full_reg/screen/emp_full_reg_ui.dart';
import '../invite_emp.dart/modal/invite_emp_screen.dart';
import '../state/auth/auth_state.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.listen((_) => notifyListeners());
  }
}

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/',

    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    redirect: (context, state) {
      final session = authBloc.state.session; // use provided AuthBloc
      final status = authBloc.state.status;

      final role = session?.role;
      final isLoggedIn = session != null;
      final isFullRegistered = session?.isFullRegistered;
      final path = state.uri.path;
      final isSplash = path == '/';
      final isLogin = path == '/login';

      // Allow password setup deep links without redirecting away
      if (path == '/setup-password' || path == '/reset') return null;

      // While auth state is still loading, let splash/login stay.
      if (status == AuthStatus.initial || status == AuthStatus.loading) {
        return isSplash || isLogin ? null : '/';
      }

      // If auth is resolved and we're on splash, redirect immediately.

      if (isSplash) {
        if (!isLoggedIn) {
          return '/login';
        }

        if (role == "SUPER_ADMIN") {
          return '/admin/dashboard';
        }
        if (role == "HR") {
          return isFullRegistered! ? '/hr/dashboard' : '/hr/onbording';
        }
        if (role == "EMPLOYEE") {
          return isFullRegistered! ? '/emp/dashboard' : '/emp/onbording';
        }
        if (role == "OWNER") {
          return isFullRegistered!
              ? '/company/dashboard'
              : '/company/onboarding';
        }

        return '/login';
      }

      // 2️⃣ Not logged in → login
      if (!isLoggedIn) {
        return isLogin ? null : '/login';
      }
    

      // If logged in and currently on the login page, redirect to role dashboard
      if (isLogin) {
        if (role == "SUPER_ADMIN") {
          return '/admin/dashboard';
        }
        if (role == "HR") {
          return isFullRegistered! ? '/hr/dashboard' : '/hr/onbording';
        }
        if (role == "EMPLOYEE") {
          return isFullRegistered! ? '/emp/dashboard' : '/emp/onbording';
        }
        if (role == "OWNER") {
          return isFullRegistered!
              ? '/company/dashboard'
              : '/company/onboarding';
        }
      }

      return null;
    },

    routes: [
      // ================= SPLASH =================
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

      // ================= LOGIN =================
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/get_face',
        builder: (context, state) {
          print('GET_FACE ROUTE HIT');
          return const FaceCaptureView();
        },
      ),

      GoRoute(
        path: '/setup-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return SetPasswordScreen(token: token);
        },
      ),
      GoRoute(
        path: '/company/onboarding',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => FullRegBloc(FullRegRepository()),
            child: const CompanyRegistrationPage(),
          );
        },
      ),
      GoRoute(
        path: '/hr/onbording',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => EmpFullRegBloc(),
            child: const EmployeeOnboardingScreen(),
          );
        },
      ),
      GoRoute(
        path: '/emp/onbording',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => EmpFullRegBloc(),
            child: const EmployeeOnboardingScreen(),
          );
        },
      ),

      // ================= ADMIN =================
      ShellRoute(
        builder: (context, state, child) {
          return AdminShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (_, _) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/companies',
            builder: (_, _) => const CompanyListScreen(),
          ),
          GoRoute(
            path: '/admin/profile',
            builder: (_, _) => const AdminProfileScreen(),
          ),
          GoRoute(
            path: '/admin/deletedcompanies',
            builder: (_, _) => const DeletedCompaniesScreen(),
          ),

          GoRoute(
            path: '/admin/subscriptionadmin',
            builder: (_, _) => const SubscriptionAdminPage(),
          ),
          GoRoute(
            path: '/admin/addcompany',
            builder: (context, state) {
              return BlocProvider(
                create: (_) =>
                    AddCompanyBloc(AddCompanyRepository())
                      ..add(LoadIndustries()),
                child: const AddCompanyScreen(),
              );
            },
          ),
          GoRoute(
            path: '/company-view',
            builder: (context, state) {
              final company = state.extra as Map<String, dynamic>;

              return CompanyViewScreen(company: company);
            },
          ),
        ],
      ),

      // ================= company =================
      ShellRoute(
        builder: (context, state, child) {
          return CompanyShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/company/dashboard',
            builder: (context, state) {
              return BlocProvider(
                create: (context) =>
                    CompanyDashboardBloc(CompanyDashboardRepository()),
                child: const CompanyDashboardScreen(),
              );
            },
          ),
          GoRoute(
            path: '/company/employees',
            builder: (context, state) {
              final employeeType = state.extra as String;
              return EmployeeListScreen(employeeType: employeeType);
            },
          ),

          GoRoute(
            path: '/company/profile',
            builder: (_, _) => const CompanyProfileScreen(),
          ),
          GoRoute(
            path: '/company/subscription',
            builder: (_, _) => const SubscriptionPage(),
          ),

          GoRoute(
            path: '/company/Projects',
            builder: (_, _) => const EmployeeProjectScreen(),
          ),
          GoRoute(
            path: '/company/empcreate',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => InviteEmpBloc(InviteEmpRepo()),
                child: const InviteEmpScreen(),
              );
            },
          ),
        ],
      ),

      // ===============hr=============================
      ShellRoute(
        builder: (context, state, child) {
          return HrShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/hr/dashboard',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => HrDashboardBloc(HrDashboardRepository()),
                child: const HrDashboardScreen(),
              );
            },
          ),
          GoRoute(
            path: '/hr/projects',
            builder: (_, _) => const EmployeeProjectScreen(),
          ),
          GoRoute(
            path: '/hr/employees',
            builder: (context, state) {
              return EmployeeListScreen(employeeType: '');
            },
          ),
          GoRoute(
            path: '/hr/profile',
            builder: (_, _) => const HrProfileScreen(),
          ),

          GoRoute(
            path: '/hr/attendance',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => AttendanceBloc()..add(AttendanceStarted()),
                child: const EmployeeAttendanceScreen(),
              );
            },
          ),
          GoRoute(
            path: '/hr/empcreate',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => InviteEmpBloc(InviteEmpRepo()),
                child: const InviteEmpScreen(),
              );
            },
          ),
        ],
      ),

      // ================= employee =================
      ShellRoute(
        builder: (context, state, child) {
          return Empshell(child: child);
        },
        routes: [
          GoRoute(
            path: '/emp/dashboard',
            builder: (_, _) => const EmpDashboardScreen(),
          ),

          GoRoute(
            path: '/emp/profile',
            builder: (_, _) => const HrProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
