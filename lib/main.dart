import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hand_cric/screen/choose_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hand Cricket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const ChooseScreen(),
    );
  }
}

class AppState extends ChangeNotifier {
  bool _autoPlay = false;
  bool _updateWidget = false;
  late int _ranValue;
  Color _gridButtonColor = Colors.blue;

  bool get autoPlay => _autoPlay;
  int get ranValue => _ranValue;
  Color get gridButtonColor => _gridButtonColor;
  // Widget get
  void updateAutoPlay(bool val) {
    _autoPlay = val;
    print("value of auto play ${_autoPlay} ");
    notifyListeners();
  }

  void updateRanValue(int val) {
    _ranValue = val;
    print("value of auto play ${_ranValue} ");
    notifyListeners();
  }

  Widget updateWidget({bool val = true}) {
    _updateWidget = val;
    if (_updateWidget) {
      // _updateWidget = val;
      notifyListeners();
      return CircularProgressIndicator();
    } else {
      var random = Random();
      int ran = random.nextInt(5);
      notifyListeners();
      return Text(
        "${ran + 1}",
        style: TextStyle(fontSize: 32, color: Colors.grey),
      );
    }
  }

  void updateGridButtonColor() {
    _gridButtonColor = _gridButtonColor == Colors.blue
        ? Colors.yellow
        : Colors.blue; // Toggle color
    print("value of auto play ${_gridButtonColor} ");
    notifyListeners();
  }
}
