import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hand_cric/screen/coinTossPage.dart';
import 'package:hand_cric/screen/game_screen2.dart';
import 'package:hand_cric/screen/helloWorld.dart';
import 'package:hand_cric/screen/loginScreen.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: ElevatedButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoinTossPage(),
                  ))
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
            ),
            child: const Text("Play Online"),
          ),
        ),
        ElevatedButton(
            onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(
                            // gameType: false,
                            )),
                  )
                },
            child: const Text("Play Offline"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
            )),
      ],
    );
  }
}
