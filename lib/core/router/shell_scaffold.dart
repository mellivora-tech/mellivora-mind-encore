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
const _kText30 = Color(0x4DF0EBE0);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kSpringCurve = Cubic(0.16, 1, 0.3, 1);

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

    // Mini player effective height (animated via AnimatedContainer)
    final miniBarHeight = miniPlayerVisible ? kMiniPlayerHeight : 0.0;

    return Scaffold(
      backgroundColor: _kBgLayer1,
      body: Stack(
        children: [
          // ── Main tab content ──
          // Pushed up by mini player + nav bar
          Positioned.fill(
            bottom: 0, // Content extends to bottom; nav bar overlays
            child: Column(
              children: [
                Expanded(child: navigationShell),
                // Space for mini player (animated)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: _kSpringCurve,
                  height: miniBarHeight,
                ),
              ],
            ),
          ),

          // ── Mini Player (above Tab Bar) ──
          // #24: positioned above bottom nav bar
          // #26: adjusts with keyboard via bottomInset
          if (miniPlayerVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: _navBarHeight(context) + (hasKeyboard ? bottomInset : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: _kSpringCurve,
                height: miniBarHeight,
                child: MiniPlayer(
                  onTap: () {
                    // #25: open player overlay
                    ref.read(playerOverlayVisibleProvider.notifier).state = true;
                  },
                ),
              ),
            ),

          // ── Player Overlay (full screen, above everything) ──
          if (playerOverlayVisible) const PlayerOverlay(),
        ],
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // #26: when keyboard is up, optionally hide nav bar or keep it
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
      ),
    );
  }

  /// Get the nav bar height for positioning mini player above it
  double _navBarHeight(BuildContext context) {
    // Standard Material 3 NavigationBar height is 80
    // Plus safe area bottom padding
    return 80 + MediaQuery.of(context).viewPadding.bottom;
  }
}
