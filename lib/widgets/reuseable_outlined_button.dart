import 'package:flutter/material.dart';

class ReuseableOutlinedButton extends StatelessWidget {
  const ReuseableOutlinedButton({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
  });
  final String text;
  final Color color;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(350, 50),
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
