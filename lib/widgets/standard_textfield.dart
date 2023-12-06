import 'package:flutter/material.dart';

class StandardTextField extends StatelessWidget {
  const StandardTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.keyboardType,
  });

  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;
  // ignore: prefer_typing_uninitialized_variables
  final keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        //controllers allows for accessing what the user types in the textfield
        controller: controller,
        obscureText: obscureText,
        enableSuggestions: false,
        autocorrect: false,
        autofocus: true,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 227, 223, 223)),
          ),
          //when user clicks to type text, border will turn gray
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 192, 185, 185)),
          ),
          fillColor: const Color.fromARGB(255, 233, 229, 229),
          filled: true,
        ),
      ),
    );
  }
}
