import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/app_providers.dart';
import '../pages/player_page.dart';

const _kSpringCurve = Cubic(0.16, 1, 0.3, 1);

/// Provider to control the player overlay visibility
final playerOverlayVisibleProvider = StateProvider<bool>((ref) => false);

/// Full-screen Player overlay that slides up from bottom (#25)
class PlayerOverlay extends ConsumerStatefulWidget {
  const PlayerOverlay({super.key});

  @override
  ConsumerState<PlayerOverlay> createState() => _PlayerOverlayState();
}

class _PlayerOverlayState extends ConsumerState<PlayerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slideAnimation;

  // Drag tracking
  double _dragOffset = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 440),
    );
    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: _kSpringCurve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _open() {
    _controller.forward();
  }

  void _close() {
    _controller.reverse().then((_) {
      if (mounted) {
        ref.read(playerOverlayVisibleProvider.notifier).state = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isVisible = ref.watch(playerOverlayVisibleProvider);
    final audioId = ref.watch(currentAudioIdProvider);

    if (!isVisible || audioId == null) return const SizedBox.shrink();

    // Trigger open animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isVisible && !_controller.isCompleted && !_controller.isAnimating) {
        _open();
      }
    });

    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        // Calculate the effective offset: animation + drag
        double translateY;
        if (_isDragging) {
          translateY = _dragOffset.clamp(0.0, screenHeight);
        } else {
          translateY = screenHeight * (1 - _slideAnimation.value);
        }

        if (translateY >= screenHeight) return const SizedBox.shrink();

        return Positioned.fill(
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onVerticalDragStart: _onDragStart,
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        child: PlayerPage(audioId: audioId),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    _isDragging = true;
    _dragOffset = 0;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
      if (_dragOffset < 0) _dragOffset = 0;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final threshold = screenHeight * 0.3;

    _isDragging = false;

    if (_dragOffset > threshold || details.velocity.pixelsPerSecond.dy > 500) {
      // Close: drag exceeded 30% threshold or fast fling
      _close();
    } else {
      // Spring back
      setState(() {
        _dragOffset = 0;
      });
    }
  }
}
