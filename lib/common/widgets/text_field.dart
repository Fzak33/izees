import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines ;
  final TextInputType textInputType;
  final bool obscureText;
  const CustomTextField(

      {super.key ,
        required this.controller ,
        required this.hintText,
        this.maxLines = 1,
        this.textInputType = TextInputType.text,
        this.obscureText = false

      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        obscureText: obscureText,
       // inputFormatters: <TextInputFormatter>[],
        keyboardType: textInputType,
        controller: controller,
        decoration: InputDecoration(
          hintText: "Enter your $hintText",
          border: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black38
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black38
            ),
          ),
        ),

        maxLines: maxLines,
      ),
    );
  }
}
