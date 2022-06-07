import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_firebase/cubit/timer_cubit.dart';

class TimerComponent extends StatefulWidget {
  const TimerComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<TimerComponent> createState() => _TimerComponentState();
}

class _TimerComponentState extends State<TimerComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TimerCubit>().state;

    return BlocListener<TimerCubit, TimerState>(
      listener: (context, state) {
        if (state.isActive) {
          _controller.repeat();
        } else {
          _controller.stop();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final popupSize = constraints.maxWidth;
          return Stack(
            children: [
              SizedBox(
                height: constraints.maxWidth,
                width: constraints.maxWidth,
                child: ClipRRect(
                  child: CustomPaint(
                    painter: TimerPainter(
                        totalTime: state.totalTime,
                        currentTime: state.currentTime,
                        listenable: _controller,
                        isBreakTime: state.isBreakTime),
                  ),
                ),
              ),
              if (state.isLoading)
                Positioned(
                  left: (constraints.maxWidth / 2) - popupSize / 2,
                  bottom: (constraints.maxWidth / 2) - popupSize / 2,
                  child: SizedBox(
                    width: popupSize,
                    height: popupSize,
                    child: const CupertinoPopupSurface(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final int currentTime;
  final int totalTime;
  final bool isBreakTime;
  Animation<double> listenable;
  TimerPainter(
      {required this.currentTime,
      required this.totalTime,
      required this.listenable,
      required this.isBreakTime})
      : super(repaint: listenable);
  @override
  void paint(Canvas canvas, Size size) {
    const outerstrokeWidth = 16.0;
    const innerstrokeWidth = 5.0;
    const minusBorder = 15;
    final cirlceSize =
        Size(size.width - minusBorder, size.height - minusBorder);
    final Offset middle =
        cirlceSize.center(const Offset(minusBorder / 2, minusBorder / 2));
    canvas.drawCircle(
      middle,
      (cirlceSize.width - innerstrokeWidth) / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey
        ..strokeWidth = innerstrokeWidth,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: middle,
        radius: (cirlceSize.width - (outerstrokeWidth / 2)) / 2,
      ),
      math.pi + (math.pi / 2),
      math.pi * map(currentTime.toDouble(), 0, totalTime.toDouble(), 0, 2),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..shader = LinearGradient(
                colors: isBreakTime
                    ? [
                        Colors.purple,
                        Colors.deepPurple,
                      ]
                    : [
                        const Color(0xFFf52e2e),
                        const Color(0xffc42525),
                      ],
                begin: const Alignment(-1.0, 0.0),
                end: const Alignment(1.0, 0.0),
                transform: GradientRotation(
                    map(listenable.value, 0, 1, 0, math.pi * 2)))
            .createShader(
          Rect.fromLTWH(minusBorder / 2, minusBorder / 2, cirlceSize.width,
              cirlceSize.height),
        )
        ..strokeWidth = outerstrokeWidth
        ..strokeCap = StrokeCap.round,
    );
    final textStyle = TextStyle(
      background: Paint()..color = Colors.transparent,
      foreground: Paint()
        ..shader = LinearGradient(
          colors: isBreakTime
              ? [
                  Colors.purple,
                  Colors.blue,
                ]
              : [
                  Colors.yellow,
                  Colors.red,
                ],
          begin: const Alignment(-1, -1),
          end: const Alignment(1, 1),
          transform: GradientRotation(
            map(listenable.value, 0, 1, 0, math.pi * 2),
          ),
        ).createShader(
          Rect.fromLTWH(minusBorder / 2, minusBorder / 2, cirlceSize.width,
              cirlceSize.height),
        ),
      fontSize: 70,
      fontWeight: FontWeight.bold,
    );

    var message = '';
    final mins = currentTime ~/ 60;
    final secs = currentTime % 60;
    if (mins.toString().length == 1) {
      message += '0$mins';
    } else {
      message += '$mins';
    }
    message += ' : ';

    if (secs.toString().length == 1) {
      message += '0$secs';
    } else {
      message += '$secs';
    }
    final textSpan = TextSpan(
      text: message,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  double map(
      double x, double inMin, double inMax, double outMin, double outMax) {
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
