import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import 'weekly_report_service.dart';

// ── Design tokens ──────────────────────────────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kGreen = Color(0xFF4CAF50);

/// #38: Weekly learning report detail page.
class WeeklyReportPage extends ConsumerStatefulWidget {
  const WeeklyReportPage({super.key});

  @override
  ConsumerState<WeeklyReportPage> createState() => _WeeklyReportPageState();
}

class _WeeklyReportPageState extends ConsumerState<WeeklyReportPage> {
  WeeklyReportData? _report;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    final db = ref.read(databaseProvider);
    final report = await WeeklyReportService().generateReport(db);
    if (mounted) {
      setState(() {
        _report = report;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgLayer1,
      appBar: AppBar(
        backgroundColor: _kBgLayer1,
        foregroundColor: _kTextPrimary,
        title: const Text('本周学习报告', style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _kAccent))
          : _buildReport(),
    );
  }

  Widget _buildReport() {
    final r = _report!;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Summary header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _kBgLayer2,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                '\u{1F4CA}',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 8),
              Text(
                '本周学习总结',
                style: TextStyle(
                  color: _kTextPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDateRange(r.weekStartDate),
                style: const TextStyle(color: _kText40, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Stats grid
        Row(
          children: [
            Expanded(child: _statCard('听音频', '${r.audioSessions}段', Icons.headphones)),
            const SizedBox(width: 12),
            Expanded(child: _statCard('听力时长', '${r.listenedMinutes}分钟', Icons.timer)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _statCard('查词次数', '${r.queryCount}次', Icons.search)),
            const SizedBox(width: 12),
            Expanded(child: _statCard('新增词汇', '${r.newWordCount}个', Icons.add_circle_outline)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _statCard(
                '复习正确率',
                '${r.reviewAccuracy}%',
                Icons.check_circle_outline,
                valueColor: r.reviewAccuracy >= 80 ? _kGreen : _kAccent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _statCard('复习总数', '${r.totalReviews}次', Icons.replay)),
          ],
        ),

        if (r.hardestWord.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _kBgLayer2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: _kAccent, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '最难的词',
                        style: TextStyle(color: _kText40, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        r.hardestWord,
                        style: const TextStyle(
                          color: _kTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 32),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: _kAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '继续加油',
                style: TextStyle(
                  color: _kBgLayer1,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kBgLayer2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _kText40, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? _kTextPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: _kText70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime start) {
    final end = start.add(const Duration(days: 6));
    return '${start.month}/${start.day} - ${end.month}/${end.day}';
  }
}
