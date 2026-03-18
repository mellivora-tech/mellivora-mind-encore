import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/services/openai_service.dart';
import 'agent_context.dart';
import 'agent_context_provider.dart';

/// Chat message model.
class ChatMessage {
  final String role; // 'user', 'assistant', 'system'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, String> toApiMessage() => {'role': role, 'content': content};
  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        role: json['role'] as String,
        content: json['content'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

/// Agent chat state.
class AgentChatState {
  final List<ChatMessage> messages;
  final bool isStreaming;
  final String? sessionId;
  final AgentMode mode;
  final String streamingBuffer;

  const AgentChatState({
    this.messages = const [],
    this.isStreaming = false,
    this.sessionId,
    this.mode = AgentMode.freeChat,
    this.streamingBuffer = '',
  });

  AgentChatState copyWith({
    List<ChatMessage>? messages,
    bool? isStreaming,
    String? sessionId,
    AgentMode? mode,
    String? streamingBuffer,
  }) {
    return AgentChatState(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      sessionId: sessionId ?? this.sessionId,
      mode: mode ?? this.mode,
      streamingBuffer: streamingBuffer ?? this.streamingBuffer,
    );
  }
}

/// #35: Agent chat notifier with OpenAI streaming.
class AgentChatNotifier extends StateNotifier<AgentChatState> {
  final Ref _ref;
  final AppDatabase _db;
  final OpenAIService _openai;
  static const _uuid = Uuid();

  AgentChatNotifier(this._ref, this._db, this._openai)
      : super(const AgentChatState());

  /// Start a new chat session with a given mode.
  void startSession(AgentMode mode, {String? initialWord}) {
    final sessionId = _uuid.v4();
    state = AgentChatState(
      sessionId: sessionId,
      mode: mode,
    );

    // If triggered from word card with initial word, send opening message
    if (initialWord != null) {
      _sendAutoOpening(initialWord);
    }
  }

  /// Build system prompt based on mode + context.
  String _buildSystemPrompt() {
    final ctx = _ref.read(agentContextProvider);
    final weakWords = _getWeakWordsBlock();

    final base = StringBuffer();
    base.writeln('你是一个英语学习助手。用户正在听英语音频学习。');

    if (ctx.audioTitle != null) {
      base.writeln('当前音频：${ctx.audioTitle}');
    }
    if (ctx.chapterTitle != null) {
      base.writeln('当前章节：${ctx.chapterTitle}');
    }
    if (ctx.sessionLookups.isNotEmpty) {
      base.writeln('用户本次查过的词：${ctx.sessionLookups.join(", ")}');
    }

    switch (state.mode) {
      case AgentMode.quiz:
        base.writeln('\n【出题模式】');
        base.writeln('根据以下内容给用户出题，考查词汇理解和语境运用。');
        base.writeln('每次出一道题，等用户回答后给出反馈，再出下一题。');
        base.writeln('题型包括：释义选择、填空、造句。难度根据用户水平调整。');
        if (ctx.chapterText != null) {
          final truncated = ctx.chapterText!.length > 3000
              ? ctx.chapterText!.substring(0, 3000)
              : ctx.chapterText!;
          base.writeln('\n章节内容：\n$truncated');
        }
        break;
      case AgentMode.explain:
        base.writeln('\n【解释模式】');
        base.writeln('用简洁中文解释当前章节的内容要点、语法难点和关键词汇。');
        if (ctx.chapterText != null) {
          final truncated = ctx.chapterText!.length > 3000
              ? ctx.chapterText!.substring(0, 3000)
              : ctx.chapterText!;
          base.writeln('\n章节内容：\n$truncated');
        }
        break;
      case AgentMode.freeChat:
        base.writeln('\n【自由对话模式】');
        base.writeln('回答用户关于英语学习的任何问题。用中文回答，涉及英文内容时保留原文。');
        if (ctx.currentWord != null) {
          base.writeln('用户刚查了单词：${ctx.currentWord}');
        }
        if (ctx.currentSentence != null) {
          base.writeln('当前句子：${ctx.currentSentence}');
        }
        break;
    }

    // #45: Inject memory block (weak words)
    if (weakWords.isNotEmpty) {
      base.writeln('\n【用户薄弱词汇】');
      base.writeln(weakWords);
      base.writeln('请在出题时优先考虑这些薄弱词汇。');
    }

    // #48: Adaptive difficulty
    final level = _getEstimatedLevel();
    if (level.isNotEmpty) {
      base.writeln('\n【用户水平】$level');
      base.writeln(_getDifficultyInstruction(level));
    }

    return base.toString();
  }

  /// Get weak words block for system prompt injection.
  String _getWeakWordsBlock() {
    // This would query word_memory in production;
    // for now we use session lookups as proxy
    final ctx = _ref.read(agentContextProvider);
    if (ctx.sessionLookups.isEmpty) return '';
    return ctx.sessionLookups.take(5).join(', ');
  }

  /// #48: Get estimated level from learning_patterns.
  String _getEstimatedLevel() {
    // In production, query LearningPatterns table
    // For now, return empty to use default
    return '';
  }

  /// #48: Difficulty instruction based on level.
  String _getDifficultyInstruction(String level) {
    switch (level) {
      case 'B1':
        return '出释义选择题，用简单中文解释。';
      case 'B2':
        return '出语境选择题，要求根据上下文选择正确用法。';
      case 'C1':
        return '要求用户造句，检查语法和用词准确性。';
      case 'C1+':
        return '出综合题，涉及多个词汇和复杂语境。';
      default:
        return '';
    }
  }

  /// Send user message and get streaming response.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.isStreaming) return;

    final userMsg = ChatMessage(role: 'user', content: text);
    final messages = [...state.messages, userMsg];
    state = state.copyWith(
      messages: messages,
      isStreaming: true,
      streamingBuffer: '',
    );

    // Build API messages
    final apiMessages = <Map<String, String>>[
      {'role': 'system', 'content': _buildSystemPrompt()},
      ...messages.map((m) => m.toApiMessage()),
    ];

    try {
      final buffer = StringBuffer();
      await for (final delta in _openai.chatCompletionStream(
        messages: apiMessages,
      )) {
        buffer.write(delta);
        state = state.copyWith(streamingBuffer: buffer.toString());
      }

      // Finalize assistant message
      final assistantMsg =
          ChatMessage(role: 'assistant', content: buffer.toString());
      state = state.copyWith(
        messages: [...messages, assistantMsg],
        isStreaming: false,
        streamingBuffer: '',
      );

      // Save to DB
      _saveSession();
    } catch (e) {
      debugPrint('Agent stream error: $e');
      final errorMsg = ChatMessage(
        role: 'assistant',
        content: '网络异常，请重试。',
      );
      state = state.copyWith(
        messages: [...messages, errorMsg],
        isStreaming: false,
        streamingBuffer: '',
      );
    }
  }

  /// Auto-opening for word card trigger (#36).
  Future<void> _sendAutoOpening(String word) async {
    // Insert a system-triggered first message
    final autoMsg = '帮我讲解一下 "$word" 这个词，以及它在这个语境中的用法。';
    await sendMessage(autoMsg);
  }

  /// Save session to agent_sessions table.
  Future<void> _saveSession() async {
    final sessionId = state.sessionId;
    if (sessionId == null) return;

    try {
      final ctx = _ref.read(agentContextProvider);
      final messagesJson =
          jsonEncode(state.messages.map((m) => m.toJson()).toList());

      await _db.into(_db.agentSessions).insertOnConflictUpdate(
        AgentSessionsCompanion(
          id: Value(sessionId),
          trigger: Value(ctx.trigger.name),
          audioId: Value(ctx.audioTitle),
          chapterId: Value(ctx.chapterTitle),
          messagesJson: Value(messagesJson),
        ),
      );
    } catch (e) {
      debugPrint('Failed to save agent session: $e');
    }
  }

  /// Clear current session.
  void clearSession() {
    state = const AgentChatState();
  }
}

final agentChatProvider =
    StateNotifierProvider<AgentChatNotifier, AgentChatState>((ref) {
  final db = ref.read(databaseProvider);
  final openai = ref.read(openAIServiceProvider);
  return AgentChatNotifier(ref, db, openai);
});
