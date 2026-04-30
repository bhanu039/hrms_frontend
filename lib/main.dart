import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_screen.dart';
import 'state/bloc/auth/auth_bloc.dart';
import 'state/bloc/auth/profile_cubit.dart';

void main() {
  final authBloc = AuthBloc()..add(AuthAppStarted());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(authBloc: authBloc),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
