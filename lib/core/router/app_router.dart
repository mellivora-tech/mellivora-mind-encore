import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/auth/login_page.dart';
import 'shell_scaffold.dart';
import '../../features/library/library_page.dart';
import '../../features/agent/agent_page.dart';
import '../../features/agent/weekly_report_page.dart';
import '../../features/words/words_page.dart';
import '../../features/words/flashcard_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/player/pages/player_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/library',
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/library';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      // Keep player route for deep links / direct navigation
      GoRoute(
        path: '/player/:audioId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final audioId = state.pathParameters['audioId'] ?? '';
          return PlayerPage(audioId: audioId);
        },
      ),
      // #38: Weekly report page route
      GoRoute(
        path: '/weekly-report',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WeeklyReportPage(),
      ),
      // #37: Flashcard route (for push notification deep link)
      // Usage: /flashcard?wordIds=id1,id2,id3
      GoRoute(
        path: '/flashcard',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final idsParam = state.uri.queryParameters['wordIds'];
          final wordIds = idsParam?.split(',').where((s) => s.isNotEmpty).toList();
          return FlashcardPage(wordIds: wordIds);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/agent',
                builder: (context, state) => const AgentPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/words',
                builder: (context, state) => const WordsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
