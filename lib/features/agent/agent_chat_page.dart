import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/env/env_config.dart';
import 'agent_context.dart';
import 'agent_context_provider.dart';
import 'agent_provider.dart';

// ── Design tokens ──────────────────────────────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kText20 = Color(0x33F0EBE0);

/// #35: Full-screen Agent chat page with streaming.
class AgentChatPage extends ConsumerStatefulWidget {
  const AgentChatPage({super.key});

  @override
  ConsumerState<AgentChatPage> createState() => _AgentChatPageState();
}

class _AgentChatPageState extends ConsumerState<AgentChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    ref.read(agentChatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(agentChatProvider);
    final agentCtx = ref.watch(agentContextProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // Auto-scroll when streaming
    if (chatState.isStreaming) {
      _scrollToBottom();
    }

    // Check API key
    if (!EnvConfig.hasOpenaiKey) {
      return Scaffold(
        backgroundColor: _kBgLayer1,
        appBar: AppBar(
          backgroundColor: _kBgLayer1,
          foregroundColor: _kTextPrimary,
          title: const Text('Agent', style: TextStyle(fontSize: 18)),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.key_outlined, color: _kAccent, size: 48),
                SizedBox(height: 16),
                Text(
                  'API Key 未配置',
                  style: TextStyle(
                    color: _kTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '请在 .env 文件中设置 OPENAI_API_KEY\n以使用 Agent 功能',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _kText40, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _kBgLayer1,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: _kBgLayer1,
        foregroundColor: _kTextPrimary,
        title: Column(
          children: [
            Text(
              _modeLabel(chatState.mode),
              style: const TextStyle(fontSize: 16),
            ),
            if (agentCtx.chapterTitle != null)
              Text(
                agentCtx.chapterTitle!,
                style: const TextStyle(color: _kText40, fontSize: 11),
              ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Context banner
          if (agentCtx.sessionLookups.isNotEmpty)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: _kAccent.withOpacity(0.08),
              child: Text(
                '查过的词：${agentCtx.sessionLookups.join(", ")}',
                style: const TextStyle(color: _kAccent, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: chatState.messages.length +
                  (chatState.isStreaming ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i < chatState.messages.length) {
                  return _buildBubble(chatState.messages[i]);
                }
                // Streaming indicator
                return _buildBubble(ChatMessage(
                  role: 'assistant',
                  content: chatState.streamingBuffer.isEmpty
                      ? '...'
                      : chatState.streamingBuffer,
                ));
              },
            ),
          ),

          // Input area
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              decoration: BoxDecoration(
                color: _kBgLayer2,
                border: Border(
                  top: BorderSide(color: _kText20, width: 0.5),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: const TextStyle(
                            color: _kTextPrimary, fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: '输入消息...',
                          hintStyle:
                              TextStyle(color: _kText40, fontSize: 15),
                          border: InputBorder.none,
                        ),
                        maxLines: 3,
                        minLines: 1,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: chatState.isStreaming ? null : _sendMessage,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: chatState.isStreaming
                              ? _kText20
                              : _kAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: chatState.isStreaming
                              ? _kText40
                              : _kBgLayer1,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg) {
    final isUser = msg.role == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser ? _kAccent : _kBgLayer2,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : null,
            bottomLeft: !isUser ? const Radius.circular(4) : null,
          ),
          border: isUser
              ? null
              : Border.all(color: _kText20, width: 0.5),
        ),
        child: SelectableText(
          msg.content,
          style: TextStyle(
            color: isUser ? _kBgLayer1 : _kTextPrimary,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  String _modeLabel(AgentMode mode) {
    switch (mode) {
      case AgentMode.quiz:
        return '\u{1F4DD} 出题考我';
      case AgentMode.explain:
        return '\u{1F50D} 解释这段';
      case AgentMode.freeChat:
        return '\u{1F4AC} 自由对话';
    }
  }
}
