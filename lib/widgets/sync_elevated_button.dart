import 'package:flutter/material.dart';
import 'package:photo_sync/inherited_widgets/appearance_bloc_inherited.dart';

class SyncElevatedButton extends StatelessWidget {
  final String buttonText;
  final TextStyle? buttonTextStyle;
  final Function onPressed;
  final EdgeInsetsGeometry padding;

  SyncElevatedButton({
    required this.buttonText,
    this.buttonTextStyle,
    this.padding = const EdgeInsets.all(0),
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          primary: AppearanceBlocInherited.of(context)
              .appearance
              .currentThemeData
              .accentColor,
        ),
        onPressed: () => onPressed(),
        child: Text(
          buttonText,
          style: buttonTextStyle,
        ),
      ),
    );
  }
}
