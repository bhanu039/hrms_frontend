import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/users/company/company_dashbord/companyShell_tabs.dart';
import 'package:goexperts/users/company/company_fullReg/screens/full_com_Reg_screen.dart';
import 'package:goexperts/invite_emp.dart/bloc/invite_emp_bloc.dart';
import 'package:goexperts/invite_emp.dart/modal/invite_emp_repo.dart';
import 'package:goexperts/core/state/auth/auth_bloc.dart';

import 'package:flutter/material.dart';
import 'package:goexperts/core/widgets/face_detact.dart';
import 'package:goexperts/core/set_password_screen.dart';
import '../../users/admin/industry_Type/Industry_repo.dart';
import '../../users/admin/industry_Type/bloc/industry_Type_bloc.dart';
import '../../users/admin/industry_Type/data/industry_Type_screen.dart';
import '../../users/employe/emp_full_reg/bloc/emp_full_bloc.dart';
import '../../users/employe/emp_full_reg/screen/emp_full_reg_ui.dart';
import '../../leaves/leave_types/bloc/leave_type_bloc.dart';
import '../../leaves/leave_repo.dart';
import '../../leaves/leave_types/data/leave_type_screen.dart';
import '../../leaves/leaves_request/bloc/leave_request_bloc.dart';
import '../../leaves/leaves_request/data/leave_request_screen.dart';
import '../../leaves/leaves_views/bloc/leaves_view_bloc.dart';
import '../../leaves/leaves_views/data/leaves_view.screen.dart';
import '../../users/admin/Screens/adminSell_tabs.dart';
import '../../users/admin/Screens/admin_prifile.dart';
import '../../users/admin/Screens/company_view_screen.dart';
import '../../users/admin/Screens/dashboard_screen.dart';
import '../../users/admin/Screens/subscription_plans.dart';
import '../../users/admin/admin_profile/profile_cubit.dart';
import '../../company_list/bloc/company_list_bloc.dart';
import '../../company_list/bloc/company_list_event.dart';
import '../../company_list/data/company_list_screen.dart';
import '../../users/admin/company_reg/bloc/company_reg_bloc.dart';
import '../../users/admin/company_reg/bloc/company_reg_event.dart';
import '../../users/admin/company_reg/data/company_reg_repository.dart';
import '../../users/admin/company_reg/screens/company_reg_ui.dart';
import '../../users/company/Screens/subscription_plans.dart';
import '../../users/company/company_dashbord/bloc/company_dashbord_bloc.dart';
import '../../users/company/company_dashbord/data/company_dashbord_repo.dart';
import '../../users/company/company_dashbord/data/company_dashbord_screen.dart';
import '../../users/company/company_fullReg/bloc/full_Reg_bloc.dart';
import '../../users/company/company_fullReg/data/repository/repository_empFullreg.dart';
import '../../users/company/company_profile/bloc/company_profile_bloc.dart';
import '../../users/company/company_profile/presentation/company_profile_screen.dart';
import '../../users/employe/emp_dashbord/bloc/emp_dashboard_bloc.dart';
import '../../users/employe/emp_dashbord/data/emp_dashboard_screen.dart';
import '../../users/employe/emp_dashbord/data/repository_emp_dashboard.dart';
import '../../users/employe/emp_dashbord/empShell_tabs.dart';
import '../../users/employe/emp_Profile/bloc/emp_profile_bloc.dart';
import '../../users/employe/emp_Profile/screen/emp_profile_screen.dart';
import '../../attendance/self_attendance/bloc/self_attendance_bloc.dart';
import '../../attendance/self_attendance/data/screen/self_attendance_ui.dart';
import '../../attendance/manage_attendance/bloc/attendance_bloc.dart';
import '../../attendance/manage_attendance/bloc/attendance_event.dart';
import '../../attendance/manage_attendance/screen/emps_attendence.dart';
import '../../emp_acceptence/bloc/emp_acceptence_bloc.dart';
import '../../emp_acceptence/bloc/emp_acceptence_event.dart';
import '../../emp_acceptence/data/emp_acceptence_repo.dart';
import '../../emp_acceptence/data/emp_acceptence_screen.dart';
import '../../emp_list/employee_list_screen.dart';
import '../../users/hr/hr_dashbord/bloc/hr_dashbord_bloc.dart';
import '../../users/hr/hr_dashbord/data/hr_dashbord_repo.dart';
import '../../users/hr/hr_dashbord/data/hr_dashbord_screenui.dart';
import '../../users/hr/hr_dashbord/hrshell_tabs.dart';
import '../../login_screen.dart';
import '../../splash_screen.dart';

//company

// HR

//employee
import '../../users/employe/Screens/project_screen.dart';
import '../../invite_emp.dart/modal/invite_emp_screen.dart';
import '../services/api_service.dart';
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
      final isFullRegistered = session?.isFullRegistered ?? false;
      final path = state.uri.path;
      final isLogin = path == '/login';

      // Allow password setup deep links without redirecting away
      if (path == '/setup-password' || path == '/reset') return null;

      // While auth state is still loading, let splash/login stay.
      if (status == AuthStatus.initial || status == AuthStatus.loading) {

        return  isLogin ? null : '/';
      }

      // If auth is resolved and we're on splash, redirect immediately.

      

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
          debugPrint('GET_FACE ROUTE HIT');
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
      GoRoute(path:"/leaves/requests",builder: (context, state) {
        return BlocProvider(
          create: (_) => LeaveBloc( LeaveRepository()),
          child: const ApplyLeaveScreen(),
        );
      },),

      
       GoRoute(
            path: '/leaveTypes',
            builder: (context, state) => BlocProvider(
              create: (_) => LeaveBloc( LeaveRepository()),
              child: const LeaveTypesScreen(),
            ),
          ),
           GoRoute(
            path: '/IndustryType',
            builder: (context, state) => BlocProvider(
              create: (_) => IndustryTypeBloc(repository:  IndustryRepository()),
              child: const IndustryTypesScreen(),
            ),
          ),

           GoRoute(
            path: '/Leaves/:listType',
            builder: (context, state) {
              final listType = state.pathParameters['listType'];
              return BlocProvider(
                create: (_) => LeavesViewBloc(repository: LeaveRepository()),
                child: LeavesViewScreen(listType: listType!),
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
      GoRoute(
        path: '/hr/attendance/self',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => SelfAttendanceBloc(),
            child: const SelfAttendanceScreen(),
          );
        },
      ),
      GoRoute(
        // The colon (:) creates a dynamic path parameter named employeeId
        path: '/onboarding/review/:employeeId',
        builder: (context, state) {
          // Extract the dynamic parameter value safely from pathParameters
          final String employeeId = state.pathParameters['employeeId'] ?? '';

          // Wrap the screen inside BlocProvider to manage local memory states
          return BlocProvider(
            create: (context) =>
                OnboardingReviewBloc(
                  repository:
                      OnboardingRepository(), // Inject the API repo layer
                )..add(
                  LoadOnboardingDetails(employeeId),
                ), // Instantly triggers the GET API call on load
            child: const OnboardingReviewScreen(),
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
            builder: (context, state) => BlocProvider(
              create: (_) => CompaniesBloc(),
              child: const CompaniesScreen(),
            ),
          ),
         
          GoRoute(
            path: '/admin/profile',
            builder: (context, state) => BlocProvider<ProfileCubit>(
              create: (context) => ProfileCubit(context.read<AuthBloc>()),
              child: const AdminProfileScreen(),
            ),
          ),

          GoRoute(
            path: '/admin/deletedcompanies',
            builder: (context, state) => BlocProvider(
              // Injecting the BLoC and immediately triggering the first data fetch
              create: (context) => CompaniesBloc()..add(FetchCompanies()),
              child: const CompaniesScreen(),
            ),
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
            path: '/company/profile',
            builder: (context, state) {
              return BlocProvider(
                create: (_) =>
                    CompanyProfileBloc(apiService: ApiService())
                      ..add(const FetchCompanyProfileEvent()),
                child: const CompanyProfileScreen(),
              );
            },
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
            path: '/company/employees',
            builder: (context, state) {
              final Map<String, dynamic>? data =
                  state.extra as Map<String, dynamic>?;

              // Provide null or default values if they are not passed
              final String? role = data?['role'];

              return EmployeeListScreen(role: role!);
            },
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
              final Map<String, dynamic>? data =
                  state.extra as Map<String, dynamic>?;

              // Provide null or default values if they are not passed
              final String? role = data?['role'];

              return EmployeeListScreen(role: role!);
            },
          ),
          GoRoute(
            path: '/hr/profile',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => EmpProfileBloc(),
                child: const EmpProfileScreen(),
              );
            },
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
            builder: (context, state) {
              return BlocProvider(
                create: (context) => EmpDashboardBloc(RepositoryEmpDashboard()),
                child: const EmpDashboardScreen(),
              );
            },
          ),
          GoRoute(
            path: '/emp/attendance/self',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => SelfAttendanceBloc(),
                child: const SelfAttendanceScreen(),
              );
            },
          ),
          

          GoRoute(
            path: '/emp/profile',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => EmpProfileBloc(),
                child: const EmpProfileScreen(),
              );
            },
          ),
        ],
      ),
    ],
  );
}
