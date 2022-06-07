import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
        child: CustomScrollView(
      slivers: [
        const CupertinoSliverNavigationBar(
          previousPageTitle: 'Home',
          largeTitle: Text('Sobre'),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Técnica pomodoro',
                  style: theme.textTheme.navLargeTitleTextStyle
                      .copyWith(fontSize: 24),
                ),
                const Text('''
A Técnica Pomodoro é um método de gerenciamento de tempo desenvolvido por Francesco Cirillo no final dos anos 1980. 

A técnica consiste na utilização de um cronômetro para dividir o trabalho em períodos de 25 minutos, separados por breves intervalos.

A técnica deriva seu nome da palavra italiana pomodoro (tomate), como referência ao popular cronômetro gastronômico na forma dessa fruta. 

O método é baseado na ideia de que pausas frequentes podem aumentar a agilidade mental.
'''),
                Text(
                  'Este app tem como inspiração a técnica pomodoro.',
                  style: theme.textTheme.textStyle.copyWith(
                    fontSize: 12,
                    color: CupertinoColors.inactiveGray.resolveFrom(context),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: CupertinoButton.filled(
                    child: const Text('Tecnologias Usadas'),
                    onPressed: () {
                      showLicensePage(context: context);
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
