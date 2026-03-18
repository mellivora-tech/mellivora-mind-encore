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
const _kEaseOutExpo = Cubic(0.16, 1, 0.3, 1);

class ShellScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({
    required this.navigationShell,
    super.key,
  });

  @override
  ConsumerState<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends ConsumerState<ShellScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _overlayController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _miniPlayerFade;

  /// Keep overlay in widget tree during reverse animation.
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();

    // #25: AnimationController managed here, drives both overlay slide
    // and mini player fade.
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 440),
    );

    // SlideTransition: Offset(0,1) → Offset(0,0)
    // Curve applied via animateTo(), so drag remains linear.
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(_overlayController);

    // FadeTransition synced: opacity 1 when closed, 0 when open
    _miniPlayerFade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_overlayController);

    _overlayController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && mounted) {
        setState(() => _showOverlay = false);
        ref.read(playerOverlayVisibleProvider.notifier).state = false;
      }
    });
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    // #25: react to overlay visibility changes from any source (e.g. back button)
    ref.listen(playerOverlayVisibleProvider, (prev, next) {
      if (next) {
        setState(() => _showOverlay = true);
        _overlayController.animateTo(1.0, curve: _kEaseOutExpo);
      } else {
        _overlayController.animateTo(0.0, curve: _kEaseOutExpo);
      }
    });

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
              child: widget.navigationShell,
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
          // #25: FadeTransition synced with overlay animation
          // #26: AnimatedPositioned moves with keyboard, 250ms easeOut
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            left: 0,
            right: 0,
            bottom: navBarTotal + bottomInset,
            child: FadeTransition(
              opacity: _miniPlayerFade,
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
                          setState(() => _showOverlay = true);
                          _overlayController.animateTo(1.0,
                              curve: _kEaseOutExpo);
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),

          // ── Player Overlay (full screen, above everything) ──
          // #25: SlideTransition begin: Offset(0,1) → end: Offset(0,0), 440ms
          if (_showOverlay)
            Positioned.fill(
              child: SlideTransition(
                position: _slideAnimation,
                child: PlayerOverlay(
                  animationController: _overlayController,
                ),
              ),
            ),
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
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
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
