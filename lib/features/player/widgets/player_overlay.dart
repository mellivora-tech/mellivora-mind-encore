import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/app_providers.dart';
import '../pages/player_page.dart';

const _kEaseOutExpo = Cubic(0.16, 1, 0.3, 1);

/// Full-screen Player overlay with drag-to-dismiss (#25).
///
/// The [animationController] is owned by ShellScaffold and drives both
/// the slide transition (wrapping this widget) and the mini player fade.
/// During drag, we set controller.value directly for linear 1:1 tracking.
/// On release, animateTo applies the easeOutExpo curve.
class PlayerOverlay extends ConsumerWidget {
  final AnimationController animationController;

  const PlayerOverlay({super.key, required this.animationController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioId = ref.watch(currentAudioIdProvider);

    if (audioId == null) return const SizedBox.shrink();

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final screenHeight = MediaQuery.of(context).size.height;
        final delta = details.delta.dy / screenHeight;
        // Dragging down → decrease value (1 = open, 0 = closed)
        animationController.value = (animationController.value - delta).clamp(0.0, 1.0);
      },
      onVerticalDragEnd: (details) {
        // Dismiss if dragged > 30% (value < 0.7) or fast fling downward
        if (animationController.value < 0.7 || details.velocity.pixelsPerSecond.dy > 500) {
          animationController.animateTo(0.0, curve: _kEaseOutExpo);
        } else {
          // Spring back to fully open
          animationController.animateTo(1.0, curve: _kEaseOutExpo);
        }
      },
      child: PlayerPage(audioId: audioId),
    );
  }
}
