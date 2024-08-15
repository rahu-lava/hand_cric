import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericTextField extends StatelessWidget {  
  // final double height;
  final String hint;
  final TextEditingController controller;

  const NumericTextField({
    super.key,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)
      ],
      decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      minLines: 1,
      // maxLength: 10,

      maxLines: null,
      // height: height,
    );
  }
}
