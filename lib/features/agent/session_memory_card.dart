import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/services/weakness_service.dart';
import 'agent_chat_page.dart';
import 'agent_context.dart';
import 'agent_context_provider.dart';
import 'agent_provider.dart';

// ── Design tokens ──────────────────────────────────────────
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kText20 = Color(0x33F0EBE0);

/// #46: Session opening memory card types.
enum MemoryCardType {
  weakWords,
  continueAudio,
  review,
  none,
}

/// #46: Check which memory card to show on app foreground.
class SessionMemoryChecker {
  final AppDatabase _db;
  final WeaknessService _weaknessService;

  SessionMemoryChecker(this._db, this._weaknessService);

  Future<MemoryCardInfo?> check() async {
    final prefs = await SharedPreferences.getInstance();
    final lastInteraction = prefs.getInt('last_agent_interaction_ms') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final hoursSince = (now - lastInteraction) / (1000 * 60 * 60);

    // Check if dismissed today
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // > 8h + has weak words not tested
    if (hoursSince > 8) {
      final dismissed = prefs.getString('dismissed_weak_$today') != null;
      if (!dismissed) {
        final weakWords = await (_db.select(_db.wordMemory)
              ..where((t) => t.weakFlag.equals(true))
              ..limit(3))
            .get();
        if (weakWords.isNotEmpty) {
          return MemoryCardInfo(
            type: MemoryCardType.weakWords,
            message: '你有 ${weakWords.length} 个薄弱词需要练习，花几分钟巩固一下？',
          );
        }
      }
    }

    // > 48h + has unfinished audio
    if (hoursSince > 48) {
      final dismissed = prefs.getString('dismissed_continue_$today') != null;
      if (!dismissed) {
        final unfinished = await (_db.select(_db.playbackState)
              ..where((t) => t.lastPositionMs.isBiggerThanValue(0))
              ..limit(1))
            .get();
        if (unfinished.isNotEmpty) {
          return MemoryCardInfo(
            type: MemoryCardType.continueAudio,
            message: '上次听到一半的音频还在等你，继续听？',
          );
        }
      }
    }

    // > 72h → review reminder
    if (hoursSince > 72) {
      final dismissed = prefs.getString('dismissed_review_$today') != null;
      if (!dismissed) {
        return MemoryCardInfo(
          type: MemoryCardType.review,
          message: '好久没复习了，来回顾一下之前学的词？',
        );
      }
    }

    return null;
  }

  Future<void> dismiss(MemoryCardType type) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    switch (type) {
      case MemoryCardType.weakWords:
        await prefs.setString('dismissed_weak_$today', 'true');
        break;
      case MemoryCardType.continueAudio:
        await prefs.setString('dismissed_continue_$today', 'true');
        break;
      case MemoryCardType.review:
        await prefs.setString('dismissed_review_$today', 'true');
        break;
      case MemoryCardType.none:
        break;
    }
  }

  Future<void> recordInteraction() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'last_agent_interaction_ms', DateTime.now().millisecondsSinceEpoch);
  }
}

class MemoryCardInfo {
  final MemoryCardType type;
  final String message;

  MemoryCardInfo({required this.type, required this.message});
}

/// #46: Memory card widget shown at top of Agent tab.
class SessionMemoryCardWidget extends ConsumerStatefulWidget {
  const SessionMemoryCardWidget({super.key});

  @override
  ConsumerState<SessionMemoryCardWidget> createState() =>
      _SessionMemoryCardWidgetState();
}

class _SessionMemoryCardWidgetState
    extends ConsumerState<SessionMemoryCardWidget> {
  MemoryCardInfo? _cardInfo;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _checkMemory();
  }

  Future<void> _checkMemory() async {
    final db = ref.read(databaseProvider);
    final weakness = ref.read(weaknessServiceProvider);
    final checker = SessionMemoryChecker(db, weakness);
    final info = await checker.check();
    if (mounted) {
      setState(() => _cardInfo = info);
    }
  }

  void _onAccept() {
    if (_cardInfo == null) return;

    setState(() => _visible = false);

    switch (_cardInfo!.type) {
      case MemoryCardType.weakWords:
        ref.read(agentChatProvider.notifier).startSession(AgentMode.quiz);
        ref
            .read(agentContextProvider.notifier)
            .setTrigger(AgentTrigger.sessionOpen);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AgentChatPage()));
        break;
      case MemoryCardType.continueAudio:
        // Navigate to player — handled by parent
        break;
      case MemoryCardType.review:
        ref.read(agentChatProvider.notifier).startSession(AgentMode.quiz);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AgentChatPage()));
        break;
      case MemoryCardType.none:
        break;
    }
  }

  void _onDismiss() async {
    if (_cardInfo == null) return;

    final db = ref.read(databaseProvider);
    final weakness = ref.read(weaknessServiceProvider);
    final checker = SessionMemoryChecker(db, weakness);
    await checker.dismiss(_cardInfo!.type);

    if (mounted) setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_cardInfo == null || !_visible) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kBgLayer2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kAccent.withOpacity(0.3), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('\u{1F916}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text(
                'Agent',
                style: TextStyle(
                  color: _kAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _cardInfo!.message,
            style: const TextStyle(
              color: _kTextPrimary,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: _onAccept,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _kAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '好',
                    style: TextStyle(
                      color: _kBgLayer2,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _onDismiss,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: _kText20, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '等等',
                    style: TextStyle(
                      color: _kText40,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final sessionMemoryCheckerProvider = Provider<SessionMemoryChecker>((ref) {
  final db = ref.read(databaseProvider);
  final weakness = ref.read(weaknessServiceProvider);
  return SessionMemoryChecker(db, weakness);
});
