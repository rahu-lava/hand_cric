import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_cric/main.dart';
import 'package:hand_cric/screen/coinTossPage.dart';
import 'package:hand_cric/screen/online_menu.dart';
import 'package:hand_cric/widgets/NumericTextField.dart';
import 'package:hand_cric/widgets/OtpField.dart';
import 'package:appwrite/appwrite.dart' as ap;
import 'package:provider/provider.dart';

late ap.Client client;
late ap.Account account;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _textEditingController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  late TextEditingController otpController;
  bool isOtpSend = false;
  bool isLoading = false; // State to manage loading
  late bool isLoggedIn;
  late bool isNameSet;

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    account = appState.account; // Access the account
    client = appState.client; // Access the client if needed
    isLoggedIn = appState.isLogged;
    // isNameSet = appState.isNameSet;

    alreadySignedIn();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   width: 175,
              //   padding: const EdgeInsets.symmetric(horizontal: 7),
              //   decoration: BoxDecoration(
              //     border: Border.all(width: 1, color: Colors.grey),
              //     borderRadius: const BorderRadius.all(Radius.circular(15)),
              //   ),
              //   child: TextFormField(
              //     controller: usernameController,
              //     keyboardType: TextInputType.text,
              //     decoration: InputDecoration(
              //         hintText: "Username", border: InputBorder.none),
              //     inputFormatters: [LengthLimitingTextInputFormatter(10)],
              //   ),
              // ),
              // SizedBox(height: 35),
              Container(
                width: 175,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: NumericTextField(
                  hint: "Enter Mobile Number",
                  controller: _textEditingController,
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true; // Show loading indicator
                        });
                        sendOTP("+91${_textEditingController.text}");
                      },
                      child: const Text("Send OTP"),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendOTP(String phoneNumber) async {
    if ((usernameController.text.isNotEmpty &&
            usernameController.text.length <= 10) &&
        (_textEditingController.text.isNotEmpty &&
            _textEditingController.text.length == 10)) {
      try {
        final token = await account.createPhoneToken(
            userId: ap.ID.unique(), phone: phoneNumber);
        final userId = token.userId;
        if (userId != null) {
          otpLikho(context, account, userId);
        }
      } catch (e) {
        setState(() {
          isLoading = false; // Stop loading
          print("Error occurred while sending OTP: $e");
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a valid input'),
        backgroundColor:
            Colors.red, // Optional: Set background color for the Snackbar
      ));
    }
  }

  Future<bool> checkSession(ap.Account account) async {
    try {
      User result = await account.get();
      print('User is logged in: ${result.name}');
      return true;
    } catch (e) {
      print('No active session: $e');
      return false;
    }
  }

  Future<String?> otpLikho(
      BuildContext context, ap.Account account, String userId) async {
    otpController = TextEditingController();
    print("me yeha hun");

    return await showDialog<String>(
      context: context,
      barrierDismissible: false, // Prevents dialog from closing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter OTP'),
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              hintText: 'Enter 6-digit OTP',
              counterText: '', // Hide character counter
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                String enteredOtp = otpController.text;
                if (enteredOtp.length == 6) {
                  validateOtp(account, userId);
                  Navigator.of(context)
                      .pop(enteredOtp); // Return the entered OTP
                } else {
                  // Show error if OTP is not 6 digits
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a 6-digit OTP')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  validateOtp(ap.Account account, String userId) async {
    String otpSecret = otpController.text;
    try {
      await account.createSession(userId: userId, secret: otpSecret);
      setUsername();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OnlineMenu()));
    } catch (e) {
      print("Error here is:" + e.toString());
    }
  }

  void alreadySignedIn() async {
    try {
      User user = await account.get();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OnlineMenu()));
      // _isLogged = true;
      print('User is logged in: ${user.name}');
    } catch (e) {
      // _isLogged = false;
      print('No active session: $e');
    }
  }

  void setUsername() async {
    if (usernameController.text.isNotEmpty) {
      try {
        final response =
            await account.updateName(name: usernameController.text);
        print('User name updated: ${response.name}');
      } catch (error) {
        print('Error updating user name: $error');
      }
    }
  }
}
