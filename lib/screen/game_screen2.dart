import 'dart:async';
import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:hand_cric/screen/choose_screen.dart';

class GameScreen extends StatefulWidget {
  final String currentRole;
  const GameScreen({super.key, required this.currentRole});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;
  Timer? timer;

  bool showWidget = true;

  List<Color> _buttonColors = List<Color>.filled(6, Colors.blue);
  List<Color> _strikeColors = List<Color>.filled(3, Colors.green);

  late int clickedValue = 0,
      currentValue = 0,
      computerValue = 0,
      strikes = 0,
      target = 0;
  bool didPlayed = false, showValue = false, isSecondInnings = false;
  String gameStatus =
      "Stoped"; // diffrent status of game - Stoped, Resumed, Paused.
  late String plyCurrentRole = widget.currentRole;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == "AppLifecycleState.paused") {
      _showMyDialog(context, "Paused", "Game has been paused", "Resume");
      controller.reset();
      _resetButtonColor();
    } else if (state == "AppLifecycleState.resumed") {}
  }

  void _showMyDialog(
      BuildContext context, String title, String content, String buttonText) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                switch (buttonText) {
                  case "Home":
                    controller.reset();
                    gameStatus = "Stoped";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseScreen()));
                  case "Batting" || "Bowling":
                    Navigator.of(context).pop();
                } // Dismiss the dialog
              },
            ),
            // TextButton(
            //   child: const Text('OK'),
            //   onPressed: () {
            //     // Perform some action
            //     Navigator.of(context).pop(); // Dismiss the dialog
            //   },
            // ),
          ],
        );
      },
    );
  }

  void timerSetter() {
    controller.forward();
    timer = Timer(const Duration(seconds: 5), () {
      computerValue = generateRandom();
      // computerValue = 4;
      updateScore();
      pauseTimer();
      // Stop the animation after 5 seconds
    });
  }

  void pauseTimer() {
    timer = Timer(const Duration(seconds: 2), () {
      controller.reset();
      // currentValue = 0;
      _resetButtonColor();
      // clickedValue = 0;
      // widget.onUpdate(false);
      // Provider.of<AppState>(context, listen: false).updateAutoPlay(true);
      setState(() {
        showValue = false;
      });
      if (gameStatus == "Resumed") {
        timerSetter();
      }
    });
  }

  _changeButtonColor(int index) {
    // _resetButtonColor();
    didPlayed = true;
    setState(() {
      // print("hey there");
      //reseting the button colors
      _buttonColors = List<Color>.filled(6, Colors.blue);
      //setting the clicked button to yellow
      _buttonColors[index] = Colors.yellow;
      //updating the clicked value
      clickedValue = index + 1;
    });
  }

  void _resetButtonColor() {
    setState(() {
      _buttonColors = List<Color>.filled(6, Colors.blue);
      clickedValue = 0;
      // _resetWidget();
    });
  }

  generateRandom() {
    var random = new Random();
    // int num = random.nextInt(6);
    // print(num);
    return random.nextInt(6) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChooseScreen()));
            },
            icon: Icon(Icons.arrow_back)),
        actions: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://as1.ftcdn.net/v2/jpg/05/11/55/90/1000_F_511559080_X4IGkzJKv3ZrHbp2wB0MmJ3DC9noNQIr.jpg'),
              ),
              SizedBox(
                width: 20,
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Text(
                      'Computer Playing...',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                        visible: showValue,
                        child: Text(
                          "$computerValue",
                          style: const TextStyle(
                              fontSize: 24, color: Colors.green),
                        )),
                    Visibility(
                        visible: !showValue,
                        child: const CircularProgressIndicator()),
                    const SizedBox(
                      height: 25,
                    ),
                    AnimatedFlipCounter(
                      value: currentValue,
                      // suffix: " run",
                      textStyle:
                          const TextStyle(fontSize: 72, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "$clickedValue",
                      style: const TextStyle(fontSize: 32, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ),
          //The Playing Pad
          Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [Text("Rahul")],
                      ),
                      Column(
                        children: [
                          Text(plyCurrentRole),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle, color: _strikeColors[0]),
                              Icon(Icons.circle, color: _strikeColors[1]),
                              Icon(Icons.circle, color: _strikeColors[2]),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Visibility(
                    visible: showWidget,
                    child: TextButton(
                        onPressed: () {
                          gameStatus = "Resumed";
                          setState(() {
                            showWidget = !showWidget;
                          });
                          timerSetter();
                        },
                        child: const Text("Click to Start"))),
                Visibility(
                    visible: !showWidget,
                    child: LinearProgressIndicator(
                      value: controller.value,
                      backgroundColor: Colors.yellow,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ))
              ],
            ),
          ),
          Center(
            child: Container(
              width: 450,
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                children: List.generate(6, (index) {
                  return Container(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shadowColor: Colors.blue,
                          backgroundColor: _buttonColors[index],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () => _changeButtonColor(index),
                      child: Text('${index + 1}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 28.0)),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String str, int mil) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: mil),
    );

    // Find the ScaffoldMessenger in the widget tree and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateScore() {
    if (didPlayed) {
      didPlayed = false;
    } else {
      clickedValue = generateRandom();
      _showSnackBar(context, "Randomly played this round", 1500);
    }
    setState(() {
      showValue = true;
      if (computerValue != clickedValue) {
        if (plyCurrentRole == "Batting") {
          currentValue += clickedValue;
        } else {
          currentValue += computerValue;
        }
      } else {
        _showSnackBar(context, "Strike", 1800);
        strikes++;
        for (int i = 0; i < strikes && i < 3; i++) {
          _strikeColors[i] = Colors.red;
        }
        // currentValue += clickedValue;
      }
      if (strikes == 3) {
        if (!isSecondInnings) {
          target = currentValue;
          _showMyDialog(context, "Innings Over", "Target is ${target + 1}",
              "${plyCurrentRole == "Batting" ? "Bowling" : "Batting"}");
          shiftInnings();
        } else {
          if (plyCurrentRole == "Batting") {
            youLost();
          } else {
            youWon();
          }
        }
      } else if (isSecondInnings && currentValue >= target) {
        if (plyCurrentRole == "Batting") {
          youWon();
        } else {
          youLost();
        }
      }
    });
  }

  void shiftInnings() {
    controller.reset();
    // timer?.cancel();
    gameStatus = "Paused";
    setState(() {
      _strikeColors = List<Color>.filled(3, Colors.green);
      currentValue = 0;
      isSecondInnings = true;
      plyCurrentRole = plyCurrentRole == "Batting" ? "Bowling" : "Batting";
      showWidget = !showWidget;
      strikes = 0;
    });
  }

  void youLost() {
    controller.reset();
    // timer?.cancel();
    gameStatus = "Paused";
    _showMyDialog(
        context,
        "You Lost",
        "You Lost the game by ${plyCurrentRole == "Bowling" ? "${3 - strikes} Strikes" : "${target - currentValue} Runs"}",
        "Home");
  }

  void youWon() {
    controller.reset();
    // timer?.cancel();
    gameStatus = "Paused";
    _showMyDialog(
        context,
        "You Won",
        "You won the game by ${plyCurrentRole == "Batting" ? "${3 - strikes} Strikes" : "${target - currentValue} Runs"}",
        "Home");
  }
}
