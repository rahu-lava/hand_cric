import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class OtpField extends StatefulWidget {
  final TextEditingController controller;
  const OtpField({super.key, required this.controller});

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6)
      ],
      maxLines: 1,
      decoration:
          InputDecoration(hintText: "Enter Otp", border: InputBorder.none),
    );
  }
}
