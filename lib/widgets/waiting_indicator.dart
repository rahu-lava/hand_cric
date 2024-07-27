import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hand_cric/main.dart';
import 'package:provider/provider.dart';

class WaitingIndicator extends StatefulWidget {
  const WaitingIndicator({Key? key}) : super(key: key);

  @override
  _WaitingIndicatorState createState() => _WaitingIndicatorState();
}

class _WaitingIndicatorState extends State<WaitingIndicator>
    with TickerProviderStateMixin {
  late AnimationController controller;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..addListener(() {
        setState(() {});
      })
      ..forward(); // Start the animation

    timer = Timer(const Duration(seconds: 5), () {
      
      controller.stop();
      setRandomValue();
      updateWidget();
      
     // Stop the animation after 5 seconds
    });
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
  
  void setRandomValue() {
    var random = Random();
    Provider.of<AppState>(context,listen: false).updateAutoPlay(true);
    Provider.of<AppState>(context,listen: false).updateRanValue(random.nextInt(5));
  }
  void updateWidget(){
    
  }
}
