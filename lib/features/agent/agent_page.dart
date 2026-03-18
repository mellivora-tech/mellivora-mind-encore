import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/env/env_config.dart';
import '../../core/services/weakness_service.dart';
import 'agent_chat_page.dart';
import 'agent_context.dart';
import 'agent_provider.dart';
import 'session_memory_card.dart';

// ── Design tokens ──────────────────────────────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kText20 = Color(0x33F0EBE0);

/// Agent tab page — shows session memory card (#46) + level card (#48).
class AgentPage extends ConsumerWidget {
  const AgentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: _kBgLayer1,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 16, 0),
              child: Text(
                'Agent',
                style: TextStyle(
                  color: _kTextPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // #46: Session memory card
            const SessionMemoryCardWidget(),

            // #48: User level card
            _LevelCard(),

            const SizedBox(height: 24),

            // Quick actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '开始对话',
                    style: TextStyle(
                      color: _kText70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _QuickAction(
                    icon: '\u{1F4DD}',
                    label: '出题考我',
                    onTap: () => _startChat(context, ref, AgentMode.quiz),
                  ),
                  const SizedBox(height: 8),
                  _QuickAction(
                    icon: '\u{1F50D}',
                    label: '解释内容',
                    onTap: () => _startChat(context, ref, AgentMode.explain),
                  ),
                  const SizedBox(height: 8),
                  _QuickAction(
                    icon: '\u{1F4AC}',
                    label: '自由对话',
                    onTap: () => _startChat(context, ref, AgentMode.freeChat),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // API key status
            if (!EnvConfig.hasOpenaiKey)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _kAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: _kAccent, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '请在 .env 中配置 OPENAI_API_KEY 以启用 Agent',
                          style: TextStyle(color: _kAccent, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _startChat(BuildContext context, WidgetRef ref, AgentMode mode) {
    if (!EnvConfig.hasOpenaiKey) return;

    ref.read(agentChatProvider.notifier).startSession(mode);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AgentChatPage()),
    );
  }
}

/// #48: User level display card.
class _LevelCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String>(
      future: ref.read(weaknessServiceProvider).getEstimatedLevel(),
      builder: (ctx, levelSnap) {
        return FutureBuilder<String>(
          future: ref.read(weaknessServiceProvider).getLevelBasis(),
          builder: (ctx, basisSnap) {
            final level = levelSnap.data ?? 'B1';
            final basis = basisSnap.data ?? '';

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _kBgLayer2,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _kAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        level,
                        style: const TextStyle(
                          color: _kAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '当前水平',
                          style: TextStyle(
                            color: _kTextPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (basis.isNotEmpty)
                          Text(
                            basis,
                            style: const TextStyle(color: _kText40, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _kBgLayer2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: _kTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: _kText40, size: 20),
          ],
        ),
      ),
    );
  }
}
