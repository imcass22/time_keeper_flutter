import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget(
      {super.key, this.onPressed, required this.buttonText});

  final Function()? onPressed;
  final String buttonText;

  //sign user up method
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(350, 50),
      ),
      onPressed: () async {
        onPressed;
      },
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
