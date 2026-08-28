import 'package:go_router/go_router.dart';

import '../features/areas/map_screen.dart';
import '../features/home/home_screen.dart';
import '../features/rooms/rooms_screen.dart';
import '../features/screen_time/screen_time_screen.dart';

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
        GoRoute(
          path: 'screen-time',
          builder: (context, state) => const ScreenTimeScreen(),
        ),
        GoRoute(
          path: 'rooms',
          builder: (context, state) => const RoomsScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => RoomScreen(
                roomId: state.pathParameters['id']!,
                roomName: state.uri.queryParameters['name'] ?? 'Odak odası',
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
