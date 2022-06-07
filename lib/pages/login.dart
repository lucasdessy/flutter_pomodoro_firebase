import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Login'),
          ),
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                  child: loading ? const CupertinoActivityIndicator() : null,
                ),
                CupertinoButton.filled(
                  onPressed: loading
                      ? null
                      : () async {
                          try {
                            setState(() {
                              loading = true;
                            });
                            await context.read<AuthCubit>().login();
                          } finally {
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                  child: const Text('Fazer login anônimo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
