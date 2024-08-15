import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hand_cric/main.dart';
import 'package:provider/provider.dart';

class WaitingIndicator extends StatefulWidget {
  //onUpdate is updating the loading widget with Text widget carring random value..
  //OnRandomCall will be executed if the player doesn't click on any button..
  final VoidCallback onUpdate;
  final Function(int) OnRandomCall;
  final VoidCallback updateWidget;
  const WaitingIndicator(
      {super.key,
      required this.onUpdate,
      required this.OnRandomCall,
      required this.updateWidget});

  @override
  _WaitingIndicatorState createState() => _WaitingIndicatorState();
}

class _WaitingIndicatorState extends State<WaitingIndicator>
    with TickerProviderStateMixin {
  late AnimationController controller;
  Timer? timer;

  // void updateWidget() {
  //   setState(() {
  //     widget.updateWidget = CircularProgressIndicator();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          });
    // Start the animation

    timerSetter();
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel(); // Cancel the timer if it's still active
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: controller.value,
      backgroundColor: Colors.yellow,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }

  void timerSetter() {
    controller.forward();
    timer = Timer(const Duration(seconds: 5), () {
      // controller.stop();
      setRandomValue();
      // updateWidget();
      widget.onUpdate();
      pauseTimer();
      // Stop the animation after 5 seconds
    });
    // widget.updateWidget();
  }

  void pauseTimer() {
    timer = Timer(Duration(seconds: 2), () {
      controller.reset();
      // widget.onUpdate(false);
      Provider.of<AppState>(context, listen: false).updateAutoPlay(true);
      timerSetter();
    });
  }

  void  setRandomValue() {
    var random = Random();
    if (Provider.of<AppState>(context, listen: false).autoPlay) {
      //Auto Play needed..
      widget.OnRandomCall(random.nextInt(6));
    }
    // Provider.of<AppState>(context, listen: false)
    //     .updateRanValue(random.nextInt(6) + 1);
  }
}
