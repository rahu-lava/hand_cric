import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:hand_cric/screen/choose_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppState();
    return MaterialApp(
      title: 'Hand Cricket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChooseScreen(),
    );
  }
}

class AppState extends ChangeNotifier {
  bool _autoPlay = true;
  bool _updateWidget = false;
  late int _ranValue;
  Color _gridButtonColor = Colors.blue;

  late Client _client;
  late Account _account;
  bool _isLogged = false;
  // bool _isNameSet = false;

  bool get autoPlay => _autoPlay;
  bool get updateWidget => _updateWidget;
  int get ranValue => _ranValue;
  Color get gridButtonColor => _gridButtonColor;

  Account get account => _account; // Expose Account as a getter
  Client get client => _client; // Expose Client as a getter
  bool get isLogged => _isLogged;
  // bool get isNameSet => _isNameSet;

  AppState() {
    _client = Client();
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('66d89345003b33f673b0')
        .setSelfSigned(status: true);

    _account = Account(_client);
    print("hey there");
    isLoggedIn();
  }

  Future<void> isLoggedIn() async {
    try {
      User user = await account.get();
      _isLogged = true;
      print('User is logged in: ${user.name}');
    } catch (e) {
      _isLogged = false;
      print('No active session: $e');
    }
  }

  // Widget get
  void updateAutoPlay(bool val) {
    _autoPlay = val;
    notifyListeners();
  }

  void updateRanValue(int val) {
    _ranValue = val;
    notifyListeners();
  }

  void updateGridButtonColor() {
    _gridButtonColor = _gridButtonColor == Colors.blue
        ? Colors.yellow
        : Colors.blue; // Toggle color
    notifyListeners();
  }
}
