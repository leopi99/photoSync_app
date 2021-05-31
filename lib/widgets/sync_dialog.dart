import 'package:flutter/material.dart';
import 'package:photo_sync/global/methods.dart';

class SyncDialog extends StatelessWidget {
  final String title;
  final String content;
  final String primaryButtonText;
  final Function primaryButtonOnPressed;
  final Function? secondaryButtonOnPressed;
  final String? secondaryButtonText;

  static show(
    BuildContext context, {
    required String title,
    required String content,
    required Function primaryButtonOnPressed,
    required String primaryButtonText,
    Function? secondaryButtonOnPressed,
    String? secondaryButtonText,
  }) async {
    await GlobalMethods.setStatusBarColorForDialog();
    var response = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: SyncDialog(
          title: title,
          content: content,
          primaryButtonOnPressed: primaryButtonOnPressed,
          primaryButtonText: primaryButtonText,
          secondaryButtonOnPressed: secondaryButtonOnPressed,
          secondaryButtonText: secondaryButtonText,
        ),
      ),
    );
    GlobalMethods.setStatusBarColorAsScaffoldBackground();
    return response;
  }

  const SyncDialog({
    required this.title,
    required this.content,
    required this.primaryButtonOnPressed,
    required this.primaryButtonText,
    this.secondaryButtonOnPressed,
    this.secondaryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(20).copyWith(bottom: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(content),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        primaryButtonOnPressed();
                      },
                      child: Text(primaryButtonText)),
                ),
              ],
            ),
            if (secondaryButtonText != null)
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (secondaryButtonOnPressed != null)
                          secondaryButtonOnPressed!();
                      },
                      child: Text(secondaryButtonText!),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
