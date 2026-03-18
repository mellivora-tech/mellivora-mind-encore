import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// #35: Agent Panel — bottom sheet with mode selection.
/// Triggered from Player's Agent button.
Future<void> showAgentPanel(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _AgentPanelContent(parentContext: context),
  );
}

class _AgentPanelContent extends ConsumerWidget {
  final BuildContext parentContext;

  const _AgentPanelContent({required this.parentContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentCtx = ref.watch(agentContextProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: _kBgLayer2,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _kText20,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              const Text(
                '\u{1F916} Agent',
                style: TextStyle(
                  color: _kTextPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              if (agentCtx.chapterTitle != null)
                Text(
                  agentCtx.chapterTitle!,
                  style: const TextStyle(color: _kText40, fontSize: 13),
                ),
              const SizedBox(height: 24),

              // Mode cards
              _ModeCard(
                icon: '\u{1F4DD}',
                title: '出题考我',
                subtitle: '根据当前章节内容出题',
                onTap: () => _startMode(context, ref, AgentMode.quiz),
              ),
              const SizedBox(height: 12),
              _ModeCard(
                icon: '\u{1F50D}',
                title: '解释这段',
                subtitle: '讲解内容要点和关键词',
                onTap: () => _startMode(context, ref, AgentMode.explain),
              ),
              const SizedBox(height: 12),
              _ModeCard(
                icon: '\u{1F4AC}',
                title: '自由对话',
                subtitle: '问任何英语学习问题',
                onTap: () => _startMode(context, ref, AgentMode.freeChat),
              ),
            ],
          ),
        );
      },
    );
  }

  void _startMode(BuildContext context, WidgetRef ref, AgentMode mode) {
    Navigator.of(context).pop(); // Close panel

    ref.read(agentChatProvider.notifier).startSession(mode);

    Navigator.of(parentContext).push(MaterialPageRoute(
      builder: (_) => const AgentChatPage(),
    ));
  }
}

class _ModeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _kText20.withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kText20, width: 0.5),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _kTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _kText40, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _kText40, size: 20),
          ],
        ),
      ),
    );
  }
}
