import 'package:flutter/material.dart';

class SyncElevatedButton extends StatelessWidget {
  final String buttonText;
  final TextStyle? buttonTextStyle;
  final Function onPressed;
  final Function? onLoginPress;

  SyncElevatedButton({
    required this.buttonText,
    this.buttonTextStyle,
    this.onLoginPress,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // primary: TODO: add the color from the appearance model (changes on darkMode)
      ),
      onPressed: () => onPressed(),
      child: Text(
        buttonText,
        style: buttonTextStyle,
      ),
    );
  }
}
