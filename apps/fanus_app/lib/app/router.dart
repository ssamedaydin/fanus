import 'package:go_router/go_router.dart';

import '../features/areas/map_screen.dart';
import '../features/home/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'map',
          builder: (context, state) => const MapScreen(),
        ),
      ],
    ),
  ],
);
