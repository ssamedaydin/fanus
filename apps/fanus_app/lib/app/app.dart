import 'package:fanus_design/fanus_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../i18n/translations.g.dart';
import 'router.dart';

class FanusApp extends StatelessWidget {
  const FanusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fanus',
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: FanusTheme.light(),
      darkTheme: FanusTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
