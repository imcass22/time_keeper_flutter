import 'package:flutter/material.dart';

class ReuseableElevatedButton extends StatelessWidget {
  const ReuseableElevatedButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });
  final String text;
  final Color color;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(350, 50),
          backgroundColor: color, //const Color.fromARGB(255, 151, 68, 62),
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
