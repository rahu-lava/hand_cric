import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:hand_cric/screen/game_screen2.dart';

class CoinTossPage extends StatefulWidget {
  const CoinTossPage({super.key});

  @override
  State<CoinTossPage> createState() => _CoinTossPageState();
}

class _CoinTossPageState extends State<CoinTossPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationCtrl;
  late Animation<double> verticalMovment;
  late Animation<double> rotation;
  final random = Random();
  late bool isHeads;

//my
  List<Color> _tossButtonColor = List<Color>.filled(2, Colors.white);
  bool toShow = false;
  late String choosedOption = "heads";

  @override
  void initState() {
    super.initState();

    animationCtrl = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    verticalMovment = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: -200),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -200, end: 0),
        weight: 50,
      ),
    ]).animate(animationCtrl);

    rotation = Tween<double>(
      begin: 0,
      end: 2 * pi * 10,
    ).animate(animationCtrl);

    isHeads = random.nextBool();

    animationCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onAnimationEnd(); // Call your function here
      }
    });
  }

  void _onAnimationEnd() {
    // This function will be called when the animation ends
    if (choosedOption == (isHeads ? "heads" : "tails")) {
      _showMyDialog(context, "You won!", "what would you like to choose", true);
      _showSnackBar(context, "You won!", 1200);
    } else {
      // bool choice = random.nextBool();
      print(isHeads);
      _showMyDialog(context, "You lost!",
          "Computer Choose to ${!isHeads ? "Bat" : "Bowl"}", false);
      _showSnackBar(context, "You lost!", 1200);
    }
  }

  void tossCoin() {
    double stopPosition = random.nextBool() ? 0.0 : 0.5;
    animationCtrl.value = stopPosition;
    animationCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: toShow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: animationCtrl,
                    builder: (BuildContext context, Widget? child) {
                      double verticalOffset = verticalMovment.value;
                      double value = rotation.value % (2 * pi);
                      // isHeads = value < pi;
                      isHeads = random.nextBool();

                      return Transform.translate(
                        offset: Offset(0, verticalOffset),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(value),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(2, 3),
                                  color: Colors.blueGrey,
                                )
                              ],
                              shape: BoxShape.circle,
                              color:
                                  isHeads ? Colors.blueAccent : Colors.blueGrey,
                            ),
                            child: Center(
                              child: Text(
                                isHeads ? 'Heads' : 'Tails',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Toss Coin'),
                    onPressed: tossCoin,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text("You choosed ${choosedOption}")
                ],
              ),
            ),
            Visibility(
                visible: !toShow,
                child: Column(
                  children: [
                    const Text("Choose : Heads or Tails"),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _tossButtonColor[0] = Colors.yellow;
                              _tossButtonColor[1] = Colors.white;
                              choosedOption = "heads";
                            });
                          },
                          child: Text("Heads"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _tossButtonColor[0],
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _tossButtonColor[0] = Colors.white;
                              _tossButtonColor[1] = Colors.yellow;
                              choosedOption = "tails";
                            });
                          },
                          child: Text("Tails"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _tossButtonColor[1],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (isOptionChoosed()) {
                              toShow = true;
                            } else {
                              _showSnackBar(context, "Choose Option!", 1200);
                            }
                          });
                        },
                        icon: Icon(Icons.arrow_forward_rounded)),
                    // Text(
                    //   "Continue -->",
                    //   style: TextStyle(decoration: TextDecoration.underline),
                    // )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationCtrl.dispose();
    super.dispose();
  }

  bool isOptionChoosed() {
    for (int i = 0; i < 2; i++) {
      if (_tossButtonColor[i] == Colors.yellow) {
        return true;
      }
    }
    return false;
  }

  void _showSnackBar(BuildContext context, String str, int mil) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: mil),
    );
    // Find the ScaffoldMessenger in the widget tree and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showMyDialog(
      BuildContext context, String title, String content, bool tossCall) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            if (tossCall) ...[
              TextButton(
                child: Text("Bat"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const GameScreen(
                                currentRole: "Batting",
                              )));
                },
              ),
              TextButton(
                child: Text('Bowl'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const GameScreen(
                                currentRole: 'Bowling',
                              )));
                },
              ),
            ] else ...[
              TextButton(
                child: const Text('Next'),
                onPressed: () {
                  // Perform some action
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => GameScreen(
                                currentRole: isHeads ? "Batting" : "Bowling",
                              )));
                  // Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ]
          ],
        );
      },
    );
  }
}
