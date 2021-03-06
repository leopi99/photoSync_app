import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_sync/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      child: App(),
      useFallbackTranslations: true,
      fallbackLocale: Locale('en'),
      useOnlyLangCode: true,
      supportedLocales: [
        Locale('en'),
        Locale('it'),
      ],
      path: 'assets/translations',
    ),
  );
}
