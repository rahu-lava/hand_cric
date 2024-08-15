import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetUserName extends StatefulWidget {
  const SetUserName({super.key});

  @override
  State<SetUserName> createState() => _SetUserNameState();
}

class _SetUserNameState extends State<SetUserName> {
  TextEditingController usernameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set User name"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Set Username:"),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 170,
              child: TextField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
