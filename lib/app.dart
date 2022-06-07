import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/auth_cubit.dart';
import 'cubit/timer_cubit.dart';
import 'pages/home.dart';
import 'pages/login.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: const CupertinoApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        home: _AppNavigator(),
      ),
    );
  }
}

class _AppNavigator extends StatelessWidget {
  const _AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    return authCubit.state.map<Widget>(
      initial: (_) => Container(),
      loggedIn: (_) =>
          BlocProvider(create: (_) => TimerCubit(), child: const HomePage()),
      loggedOut: (_) => const LoginPage(),
    );
  }
}
