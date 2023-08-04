import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 10.0),
        Text(text),
      ],
    ),
  );

  showDialog(
    context: context,
    // will not allow the user to dismiss the dialog when tapping outside of it
    barrierDismissible: false,
    builder: (context) => dialog,
  );
  //returning a function that will pop/remove the dialog
  return () => Navigator.of(context).pop();
}
