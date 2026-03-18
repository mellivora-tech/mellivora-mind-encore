import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global app state provider
final appInitializedProvider = StateProvider<bool>((ref) => false);

/// Mini player visibility state
final miniPlayerVisibleProvider = StateProvider<bool>((ref) => false);

/// Currently playing audio ID
final currentAudioIdProvider = StateProvider<String?>((ref) => null);

/// Player overlay visibility state (#25)
final playerOverlayVisibleProvider = StateProvider<bool>((ref) => false);
