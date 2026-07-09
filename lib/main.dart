import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/core/router/go_router.dart';

import 'core/app_constants/app_thems.dart';
import 'notifications/notification_repo.dart';
import 'core/theme/theme_controller.dart';
import 'core/state/auth/auth_bloc.dart';
import 'core/state/auth/auth_event.dart';
import 'core/state/bloc/deep_link/deep_link_bloc.dart';
import 'core/state/bloc/deep_link/deep_link_event.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService.initialize();
  runApp(const MyAppRoot());
}

class MyAppRoot extends StatelessWidget {
  const MyAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final appLinks = AppLinks();

    return MultiBlocProvider(
      providers: [
        /// AUTH BLOC
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc()..add(AuthAppStarted()),
        ),

        /// DEEP LINK BLOC
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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
