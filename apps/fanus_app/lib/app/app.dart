import 'package:fanus_design/fanus_design.dart';
import 'package:flutter/material.dart';

import 'router.dart';

class FanusApp extends StatelessWidget {
  const FanusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fanus',
      theme: FanusTheme.light(),
      darkTheme: FanusTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
