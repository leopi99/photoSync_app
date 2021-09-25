import 'package:flutter/services.dart';

///Collection of static methods that does not depend on anything
class GlobalMethods {
  ///Hides the keyboard
  static Future<void> hideKeyboard() async =>
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
}
