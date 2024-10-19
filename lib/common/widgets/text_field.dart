import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines ;
  final TextInputType textInputType;
  const CustomTextField(

      {super.key ,
        required this.controller ,
        required this.hintText,
        this.maxLines = 1,
        this.textInputType = TextInputType.text,

      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
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
