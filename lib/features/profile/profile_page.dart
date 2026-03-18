import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/database_provider.dart';
import '../agent/agent_push_service.dart';
import '../agent/weekly_report_page.dart';
import '../agent/weekly_report_service.dart';
import '../auth/auth_provider.dart';

// ── Design tokens ──────────────────────────────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kText20 = Color(0x33F0EBE0);
const _kGreen = Color(0xFF4CAF50);
const _kRed = Color(0xFFE57373);

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _apiKeyController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool _apiKeyObscured = true;
  bool _apiKeyValid = false;
  bool _apiKeyChecked = false;
  bool _apiKeyLoading = false;

  bool _practiceReminderEnabled = true;
  TimeOfDay _practiceReminderTime = const TimeOfDay(hour: 8, minute: 0);
  bool _weeklyReportEnabled = true;

  String _storageSizeText = '计算中...';
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    // Load API key (masked)
    final key = await _storage.read(key: 'openai_api_key');
    if (key != null && key.isNotEmpty) {
      _apiKeyController.text = key;
    }

    // Load push settings
    final prefs = await SharedPreferences.getInstance();
    _practiceReminderEnabled =
        prefs.getBool('agent_practice_push_enabled') ?? true;
    _practiceReminderTime = TimeOfDay(
      hour: prefs.getInt('agent_practice_push_hour') ?? 8,
      minute: prefs.getInt('agent_practice_push_minute') ?? 0,
    );
    _weeklyReportEnabled = prefs.getBool('weekly_report_push_enabled') ?? true;

    // Storage size
    _calculateStorageSize();

    // App version
    try {
      final info = await PackageInfo.fromPlatform();
      _appVersion = '${info.version} (${info.buildNumber})';
    } catch (_) {
      _appVersion = '0.1.0';
    }

    if (mounted) setState(() {});
  }

  Future<void> _calculateStorageSize() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      int totalSize = 0;
      await for (final entity in appDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      if (mounted) {
        setState(() {
          _storageSizeText = _formatBytes(totalSize);
        });
      }
    } catch (_) {
      if (mounted) setState(() => _storageSizeText = '未知');
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> _saveApiKey() async {
    final key = _apiKeyController.text.trim();
    await _storage.write(key: 'openai_api_key', value: key);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('API Key 已保存'),
          backgroundColor: _kBgLayer2,
        ),
      );
    }
  }

  Future<void> _validateApiKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) return;

    setState(() {
      _apiKeyLoading = true;
      _apiKeyChecked = false;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.openai.com/v1/models',
        options: Options(
          headers: {'Authorization': 'Bearer $key'},
          validateStatus: (status) => true,
        ),
      );
      setState(() {
        _apiKeyValid = response.statusCode == 200;
        _apiKeyChecked = true;
        _apiKeyLoading = false;
      });
    } catch (_) {
      setState(() {
        _apiKeyValid = false;
        _apiKeyChecked = true;
        _apiKeyLoading = false;
      });
    }
  }

  Future<void> _clearTranscriptCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _kBgLayer2,
        title: const Text('清除转录缓存', style: TextStyle(color: _kTextPrimary)),
        content: const Text(
          '将清除所有字幕和词汇数据，音频文件保留。可重新转录恢复。',
          style: TextStyle(color: _kText70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消', style: TextStyle(color: _kText40)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('清除', style: TextStyle(color: _kRed)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.delete(db.transcripts).go();
      await db.delete(db.words).go();
      // Reset transcription status so user can re-trigger
      await db.update(db.audioItems).write(
            const AudioItemsCompanion(
                transcriptionStatus: Value('pending')),
          );
      _calculateStorageSize();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('转录缓存已清除'),
            backgroundColor: _kBgLayer2,
          ),
        );
      }
    }
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _kBgLayer2,
        title: const Text('退出登录', style: TextStyle(color: _kTextPrimary)),
        content: const Text('确定要退出登录吗？', style: TextStyle(color: _kText70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消', style: TextStyle(color: _kText40)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('退出', style: TextStyle(color: _kRed)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(authStateProvider.notifier).signOut();
    }
  }

  Future<void> _pickPracticeTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _practiceReminderTime,
    );
    if (time != null) {
      setState(() => _practiceReminderTime = time);
      await AgentPushService().updateSettings(
        hour: time.hour,
        minute: time.minute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userName = authState.userName ?? '用户';
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: _kBgLayer1,
      appBar: AppBar(
        backgroundColor: _kBgLayer1,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          '我的',
          style: TextStyle(
            color: _kTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // ── Account Info ──
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _kBgLayer2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _kAccent,
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: _kBgLayer1,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: _kTextPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FutureBuilder<List<String?>>(
                        future: Future.wait([
                          ref.read(authServiceProvider).getUserEmail(),
                          const FlutterSecureStorage().read(key: 'auth_provider'),
                        ]),
                        builder: (_, snap) {
                          final email = snap.data?[0] ?? '';
                          final provider = snap.data?[1];
                          return Row(
                            children: [
                              if (email.isNotEmpty)
                                Text(
                                  email,
                                  style: const TextStyle(color: _kText40, fontSize: 13),
                                ),
                              if (provider != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: _kAccent.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    provider == 'apple' ? 'Apple' : 'Google',
                                    style: const TextStyle(
                                      color: _kAccent,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── API Key Section ──
          const SizedBox(height: 20),
          _sectionHeader('API Key 配置'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _kBgLayer2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _apiKeyController,
                  obscureText: _apiKeyObscured,
                  style: const TextStyle(color: _kTextPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'sk-...',
                    hintStyle: const TextStyle(color: _kText40),
                    filled: true,
                    fillColor: _kBgLayer1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _apiKeyObscured ? Icons.visibility_off : Icons.visibility,
                        color: _kText40,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _apiKeyObscured = !_apiKeyObscured),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _actionButton('保存', _kAccent, _saveApiKey),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _actionButton(
                        _apiKeyLoading ? '验证中...' : '验证',
                        _kText20,
                        _apiKeyLoading ? null : _validateApiKey,
                        textColor: _kTextPrimary,
                      ),
                    ),
                  ],
                ),
                if (_apiKeyChecked) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _apiKeyValid ? Icons.check_circle : Icons.cancel,
                        color: _apiKeyValid ? _kGreen : _kRed,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _apiKeyValid ? '有效' : '无效',
                        style: TextStyle(
                          color: _apiKeyValid ? _kGreen : _kRed,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ── Push Settings ──
          const SizedBox(height: 20),
          _sectionHeader('推送设置'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _kBgLayer2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('专项练习提醒',
                      style: TextStyle(color: _kTextPrimary, fontSize: 15)),
                  subtitle: Text(
                    '每天 ${_practiceReminderTime.format(context)} 检查高频查词',
                    style: const TextStyle(color: _kText40, fontSize: 12),
                  ),
                  value: _practiceReminderEnabled,
                  activeColor: _kAccent,
                  onChanged: (val) async {
                    setState(() => _practiceReminderEnabled = val);
                    await AgentPushService().updateSettings(enabled: val);
                  },
                ),
                if (_practiceReminderEnabled)
                  ListTile(
                    title: const Text('提醒时间',
                        style: TextStyle(color: _kText70, fontSize: 14)),
                    trailing: Text(
                      _practiceReminderTime.format(context),
                      style: const TextStyle(color: _kAccent, fontSize: 14),
                    ),
                    onTap: _pickPracticeTime,
                  ),
                const Divider(height: 1, color: _kText20, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text('学习周报',
                      style: TextStyle(color: _kTextPrimary, fontSize: 15)),
                  subtitle: const Text(
                    '每周日 20:00 推送本周学习数据',
                    style: TextStyle(color: _kText40, fontSize: 12),
                  ),
                  value: _weeklyReportEnabled,
                  activeColor: _kAccent,
                  onChanged: (val) async {
                    setState(() => _weeklyReportEnabled = val);
                    await WeeklyReportService().updateSettings(enabled: val);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart, color: _kText40, size: 20),
                  title: const Text('查看本周报告',
                      style: TextStyle(color: _kText70, fontSize: 14)),
                  trailing: const Icon(Icons.chevron_right, color: _kText40, size: 20),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WeeklyReportPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          // ── Storage Management ──
          const SizedBox(height: 20),
          _sectionHeader('存储管理'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _kBgLayer2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('App 数据大小',
                      style: TextStyle(color: _kTextPrimary, fontSize: 15)),
                  trailing: Text(
                    _storageSizeText,
                    style: const TextStyle(color: _kText70, fontSize: 14),
                  ),
                ),
                const Divider(height: 1, color: _kText20, indent: 16, endIndent: 16),
                ListTile(
                  title: const Text('清除已转录缓存',
                      style: TextStyle(color: _kTextPrimary, fontSize: 15)),
                  subtitle: const Text(
                    '保留音频文件，清除字幕和词汇数据',
                    style: TextStyle(color: _kText40, fontSize: 12),
                  ),
                  trailing: const Icon(Icons.delete_outline, color: _kRed, size: 20),
                  onTap: _clearTranscriptCache,
                ),
              ],
            ),
          ),

          // ── Sign Out ──
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: _kBgLayer2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: _kRed, size: 20),
              title: const Text('退出登录',
                  style: TextStyle(color: _kRed, fontSize: 15)),
              onTap: _confirmSignOut,
            ),
          ),

          // ── App Version ──
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Encore v$_appVersion',
              style: const TextStyle(color: _kText40, fontSize: 12),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _kText70,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _actionButton(
    String label,
    Color bg,
    VoidCallback? onTap, {
    Color textColor = const Color(0xFF1A1814),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
