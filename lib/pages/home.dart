import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_firebase/cubit/timer_cubit.dart';
import 'about.dart';
import 'components/timer.dart';

import '../cubit/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isActive = context.select<TimerCubit, bool>(
      (value) => value.state.isActive,
    );
    final isBreakTime = context.select<TimerCubit, bool>(
      (value) => value.state.isBreakTime,
    );
    return CupertinoPageScaffold(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Home'),
            trailing: CupertinoButton(
              borderRadius: BorderRadius.zero,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const AboutPage()));
              },
              child: const Icon(CupertinoIcons.question_circle),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Column(
                children: [
                  const TimerComponent(),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 28),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: isBreakTime
                            ? [
                                Text(
                                  'Descansar',
                                  style: theme.textTheme.navLargeTitleTextStyle
                                      .copyWith(),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  'O tempo de descanso é de ${TimerCubit.breakTime ~/ 60} minuto${(TimerCubit.breakTime ~/ 60) > 1 ? 's' : ''}',
                                  style: theme.textTheme.textStyle,
                                ),
                              ]
                            : [
                                Text(
                                  'Trabalhar',
                                  style: theme.textTheme.navLargeTitleTextStyle
                                      .copyWith(),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  'O tempo é de ${TimerCubit.workTime ~/ 60} minuto${(TimerCubit.workTime ~/ 60) > 1 ? 's' : ''}',
                                  style: theme.textTheme.textStyle,
                                ),
                              ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 55),
                        onPressed: () async {
                          context.read<TimerCubit>().reset();
                        },
                        child: const Text('Resetar'),
                      ),
                      isActive
                          ? CupertinoButton(
                              color: CupertinoColors.systemYellow,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 55),
                              onPressed: () async {
                                context.read<TimerCubit>().pause();
                              },
                              child: const Text('Pausar'),
                            )
                          : CupertinoButton(
                              color: CupertinoColors.systemYellow,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 55),
                              onPressed: () async {
                                context.read<TimerCubit>().start();
                              },
                              child: const Text('Iniciar'),
                            ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  CupertinoButton(
                    color: CupertinoColors.destructiveRed,
                    onPressed: () async {
                      await context.read<AuthCubit>().logout();
                    },
                    child: const Text('Sair'),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'user uid: ${context.select<AuthCubit, String>(
                      (AuthCubit b) => b.state.maybeMap(
                        orElse: () => '',
                        loggedIn: (state) => state.user.uid,
                      ),
                    )}',
                    style: theme.textTheme.textStyle.copyWith(
                      fontSize: 10,
                      color: CupertinoColors.inactiveGray.resolveFrom(context),
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
}
