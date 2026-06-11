import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/company/Screens/companyShell_tabs.dart';
import 'package:goexperts/company/company_fullReg/screens/full_com_Reg_screen.dart';
import 'package:goexperts/core/state/auth/auth_bloc.dart';

import 'package:flutter/material.dart';
import 'package:goexperts/core/widgets/top_message.dart';
import 'package:goexperts/core/widgets/face_detact.dart';
import 'package:goexperts/core/set_password_screen.dart';

import '../../admin/Screens/company_view_screen.dart';
import '../../admin/company_reg/bloc/company_reg_bloc.dart';
import '../../admin/company_reg/bloc/company_reg_event.dart';
import '../../admin/company_reg/data/company_reg_repository.dart';
import '../../admin/company_reg/screens/company_reg_ui.dart';
import '../../employe/Screens/empShell_tabs.dart';
import '../../employe/emp_full_reg/bloc/emp_full_bloc.dart';
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
import '../../company/Screens/c_dashboard_screen.dart';
import '../../company/Screens/company_profile_screen.dart';
import '../../company/Screens/employee_screen.dart';

// HR
import '../../hr/screens/hr_Profile.dart';
import '../../hr/screens/hr_dashbord.dart';

//employee

import '../../employe/Screens/employee_dashbord.dart';
import '../../employe/Screens/project_screen.dart';
import '../../employe/emp_full_reg/screen/emp_full_reg_ui.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',

  redirect: (context, state) {
    final session = context
        .read<AuthBloc>()
        .state
        .session; // replace with your Bloc

    final role = session?.role;
    final isLoggedIn = session != null;
    final isFullRegistered = session?.isFullRegistered ?? false;
    final path = state.uri.path;
    final isSplash = path == '/splash';
    final isLogin = path == '/login';

    // Allow password setup deep links without redirecting away
    if (path == '/setup-password' || path == '/reset') return null;

    // 1️⃣ Splash always allowed first
    if (isSplash) return null;

    // 2️⃣ Not logged in → login
    if (!isLoggedIn) {
      return isLogin ? null : '/login';
    }

    // 3️⃣ Logged in → role routing
    if (role == "SUPER_ADMIN") {
      if (isFullRegistered) {
        if (!state.uri.path.startsWith('/admin')) {
          return '/admin/dashboard';
        }
      } else {
        TopMessage.show(context, "THIS IS THE ADMIN ", color: Colors.red);
      }
    }

    if (role == "HR") {
      if (isFullRegistered) {
        if (!state.uri.path.startsWith('/hr')) {
          return '/hr/dashboard';
        }
      } else {
        context.go('/emp/onbording');
      }
    }

    if (role == "EMPLOYEE") {
      if (isFullRegistered) {
        if (!path.startsWith('/emp')) {
          return '/emp/dashboard';
        }
      } else {
        return '/emp/onbording';
      }
    }

    if (role == "OWNER") {
      if (isFullRegistered) {
        if (!state.uri.path.startsWith('/company')) {
          return '/company/dashboard';
        }
      } else {
        context.go("/company/onboarding");
      }
    }

    return null;
  },

  routes: [
    // ================= SPLASH =================
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

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
      path: '/reset',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return SetPasswordScreen(token: token);
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
                  AddCompanyBloc(AddCompanyRepository())..add(LoadIndustries()),
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
        return Companyshell(child: child);
      },
      routes: [
        GoRoute(
          path: '/company/dashboard',
          builder: (_, _) => const CDashboardScreen(),
        ),
        GoRoute(
          path: '/company/employees',
          builder: (_, _) => const EmployeeListScreen(),
        ),
        GoRoute(
          path: '/company/profile',
          builder: (_, _) => const CompanyProfileScreen(),
        ),
        GoRoute(
          path: '/company/onboarding',
          builder: (_, _) => const CompanyFullRegScreen(),
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
          builder: (_, _) => const HrDashboardScreen(),
        ),
        GoRoute(
          path: '/hr/employees',
          builder: (_, _) => const EmployeeProjectScreen(),
        ),
        GoRoute(
          path: '/hr/profile',
          builder: (_, _) => const HrProfileScreen(),
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
          path: '/emp/onbording',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => EmpFullRegBloc(),
              child: const EmployeeOnboardingScreen(),
            );
          },
        ),
        GoRoute(
          path: '/emp/profile',
          builder: (_, _) => const HrProfileScreen(),
        ),
      ],
    ),
  ],
);
