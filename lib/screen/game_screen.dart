import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:hand_cric/main.dart';
import 'package:hand_cric/widgets/waiting_indicator.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  final bool gameType;
  const GameScreen({super.key, required this.gameType});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Color> _buttonColors = List<Color>.filled(6, Colors.blue);
  int clickedValue = 0;
  late int botValue, currentScore = 0;
  Widget _currentWidget = const CircularProgressIndicator();

  void _changeButtonColor(int index) {
    setState(() {
      // Set all buttons to blue
      _buttonColors = List<Color>.filled(6, Colors.blue);
      // Set the clicked button to yellow
      _buttonColors[index] = Colors.yellow;
      clickedValue = index + 1;
    });
  }

  void _updateWidget() {
    var random = Random();
    botValue = random.nextInt(6) + 1;
    setState(() {
      _currentWidget = Text(
        '${botValue}',
        style: TextStyle(fontSize: 24, color: Colors.green),
      );
      currentScore = (botValue == clickedValue)
          ? currentScore
          : currentScore + clickedValue;
      // ResetWidgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[
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
      body: SafeArea(
          child: Container(
        // color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Column(children: [
              const Text(
                "Player Playing...",
                style: TextStyle(fontSize: 26),
              ),
              const SizedBox(
                height: 20,
              ),
              _currentWidget,
              // const CircularProgressIndicator(),
              // Provider.of<AppState>(context, listen: false).updateWidget(),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "$currentScore",
                    style: TextStyle(fontSize: 72, color: Colors.grey),
                  ),
                  // Text("+4", style: TextStyle(fontSize: 56, color: Colors.grey))
                ],
              ),
              const SizedBox(height: 25),
              Center(
                  child: Text(
                "${clickedValue}",
                style: const TextStyle(fontSize: 32, color: Colors.grey),
              )),
            ]),
            const Spacer(),
            // ElevatedButton(onPressed: () => {}, child: Text("Hey there")),
            ButtonGrid(context)
          ],
        ),
      )),
    );
  }

  Widget ButtonGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Batting",
              style: TextStyle(fontSize: 20),
            ),
            Text("World")
          ],
        ),
        WaitingIndicator(
          onUpdate: _updateWidget,
        ),
        SizedBox(
          height: 4,
        ),
        Center(
          child: Container(
              width: 450,
              // padding: const EdgeInsets.all(15.5),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: List.generate(6, (index) {
                  return Container(
                    // color: Colors.blue,
                    // height: 100,
                    // width: 100,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shadowColor: Colors.blue,
                          backgroundColor: _buttonColors[index],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))
                          // padding:
                          //     const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          ),
                      onPressed: () => _changeButtonColor(index),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 28.0),
                      ),
                    ),
                  );
                }),
              )),
        ),
      ],
    );
  }

  // Widget
}
