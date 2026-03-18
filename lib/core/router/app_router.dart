import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/auth/login_page.dart';
import 'shell_scaffold.dart';
import '../../features/library/library_page.dart';
import '../../features/agent/agent_page.dart';
import '../../features/words/words_page.dart';
import '../../features/profile/profile_page.dart';

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
      GoRoute(
        path: '/player/:audioId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final audioId = state.pathParameters['audioId'] ?? '';
          return _PlayerPlaceholder(audioId: audioId);
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

/// Placeholder player page — will be implemented in W7.
class _PlayerPlaceholder extends StatelessWidget {
  final String audioId;

  const _PlayerPlaceholder({required this.audioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1814),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1814),
        foregroundColor: const Color(0xFFF0EBE0),
        title: const Text('Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.headphones,
              size: 80,
              color: Color(0xFFF5A623),
            ),
            const SizedBox(height: 24),
            Text(
              'Player — Coming in W7',
              style: TextStyle(
                color: const Color(0xFFF0EBE0).withOpacity(0.55),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Audio: $audioId',
              style: TextStyle(
                color: const Color(0xFFF0EBE0).withOpacity(0.3),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
