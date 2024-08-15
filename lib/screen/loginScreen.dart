import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hand_cric/screen/SetUserName.dart';
import 'package:hand_cric/screen/coinTossPage.dart';
import 'package:hand_cric/widgets/NumericTextField.dart';
import 'package:hand_cric/widgets/OtpField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _otpEditingController = TextEditingController();
  bool isOtpSend = false;
  bool isLoading = false; // State to manage loading
  String _verificationId = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print(_auth);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: !isOtpSend,
                child: Column(
                  children: [
                    Container(
                      width: 175,
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: NumericTextField(
                        hint: "Enter Mobile Number",
                        controller: _textEditingController,
                      ),
                    ),
                    SizedBox(height: 20),
                    isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true; // Show loading indicator
                              });
                              sendOTP("+91" + _textEditingController.text);
                            },
                            child: Text("Send OTP"),
                          ),
                  ],
                ),
              ),
              Visibility(
                visible: isOtpSend,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 175,
                        child: OtpField(controller: _otpEditingController)),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        verifyOTP(_verificationId, _otpEditingController.text);
                      },
                      child: Text("Verify OTP"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendOTP(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Handle auto-verification
          await _auth.signInWithCredential(credential);
          setState(() {
            print(
                'Phone number automatically verified and user signed in: ${_auth.currentUser?.uid}');
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification errors
          setState(() {
            isLoading = false; // Stop loading
            print(
                'Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          // Handle OTP sent
          setState(() {
            isLoading = false; // Stop loading
            isOtpSend = true; // Show OTP input
            _verificationId = verificationId;
            print("OTP Sent!");
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading
        print("Error occurred while sending OTP: $e");
      });
    }
  }

  Future<void> verifyOTP(String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      setState(() {
        print('Successfully signed in UID: ${_auth.currentUser?.uid}');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SetUserName()));
      });
    } catch (e) {
      setState(() {
        print("Error occurred while verifying OTP: $e");
      });
    }
  }
}
