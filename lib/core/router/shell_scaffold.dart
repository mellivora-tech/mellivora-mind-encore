import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/player/widgets/mini_player.dart';
import '../../features/player/widgets/player_overlay.dart';
import '../../shared/providers/app_providers.dart';

// ── Design tokens ────────────────────────────────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);

class ShellScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({
    required this.navigationShell,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final miniPlayerVisible = ref.watch(miniPlayerVisibleProvider);
    final playerOverlayVisible = ref.watch(playerOverlayVisibleProvider);
    // #26: keyboard bottom inset
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final hasKeyboard = bottomInset > 0;
    final safePadBottom = MediaQuery.of(context).viewPadding.bottom;

    // Nav bar height: Material 3 standard 80 + safe area
    const navBarH = 80.0;
    final navBarTotal = navBarH + safePadBottom;

    // Mini player effective height (animated)
    final miniBarHeight = miniPlayerVisible ? kMiniPlayerHeight : 0.0;

    return Scaffold(
      backgroundColor: _kBgLayer1,
      resizeToAvoidBottomInset: false, // #26: handle keyboard manually
      body: Stack(
        children: [
          // ── Tab content (IndexedStack via GoRouter) ──
          // #24: all 4 tabs share the same Stack
          Positioned.fill(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.only(bottom: navBarTotal + miniBarHeight),
              child: navigationShell,
            ),
          ),

          // ── Bottom Navigation Bar ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildNavBar(context, safePadBottom),
          ),

          // ── Mini Player (above Tab Bar) ──
          // #24: positioned above bottom nav bar
          // #25: opacity fades out when overlay is open
          // #26: adjusts with keyboard via AnimatedPadding
          Positioned(
            left: 0,
            right: 0,
            bottom: navBarTotal,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.only(
                bottom: hasKeyboard ? bottomInset : 0,
              ),
              child: AnimatedOpacity(
                opacity: playerOverlayVisible ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 250),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: miniBarHeight,
                  child: miniPlayerVisible
                      ? MiniPlayer(
                          onTap: () {
                            // #25: open player overlay
                            ref
                                .read(playerOverlayVisibleProvider.notifier)
                                .state = true;
                          },
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          // ── Player Overlay (full screen, above everything) ──
          // #25: z-index 500 equivalent — last in Stack
          if (playerOverlayVisible) const PlayerOverlay(),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, double safePadBottom) {
    return Container(
      decoration: const BoxDecoration(
        color: _kBgLayer2,
      ),
      child: NavigationBar(
        backgroundColor: _kBgLayer2,
        surfaceTintColor: Colors.transparent,
        indicatorColor: _kAccent.withOpacity(0.15),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy),
            label: 'Agent',
          ),
          NavigationDestination(
            icon: Icon(Icons.abc_outlined),
            selectedIcon: Icon(Icons.abc),
            label: 'Words',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
