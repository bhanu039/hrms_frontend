import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/core/router/go_router.dart';

import 'core/state/auth/auth_bloc.dart';
import 'core/state/auth/auth_event.dart';
import 'core/state/bloc/deep_link/deep_link_bloc.dart';
import 'core/state/bloc/deep_link/deep_link_event.dart';
import 'admin/admin_profile/profile_cubit.dart';

void main() {
  runApp(const MyAppRoot());
}

class MyAppRoot extends StatelessWidget {
  const MyAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final appLinks = AppLinks();

    return MultiBlocProvider(
      providers: [
        /// ✅ AUTH BLOC
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc()..add(AuthAppStarted()),
        ),

        /// ✅ PROFILE CUBIT (SAFE DEPENDENCY)
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(context.read<AuthBloc>()),
        ),

        /// ✅ DEEP LINK BLOC
        BlocProvider<DeepLinkBloc>(
          create: (_) => DeepLinkBloc(appLinks)..add(CheckDeepLink()),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(context.read<AuthBloc>());
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
