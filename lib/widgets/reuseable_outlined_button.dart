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
          foregroundColor: Colors.black87,
          side: BorderSide(
            width: 1.0,
            color: Colors.grey[500]!,
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
