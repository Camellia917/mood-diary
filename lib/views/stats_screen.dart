import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stats_viewmodel.dart';
import 'widgets/mood_line_chart.dart';
import 'widgets/mood_pie_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsViewModel>().loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(title: const Text('心情统计'), backgroundColor: Colors.grey.shade50),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _periodPicker(vm),
                const SizedBox(height: 16),
                _summaryCards(vm),
                const SizedBox(height: 20),
                _card(child: MoodLineChart(data: vm.lineChartData)),
                const SizedBox(height: 20),
                _card(child: MoodPieChart(data: vm.pieData)),
                const SizedBox(height: 20),
                _trendCard(vm),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _periodPicker(StatsViewModel vm) {
    return SegmentedButton<StatsPeriod>(
      segments: const [
        ButtonSegment(value: StatsPeriod.last7Days, label: Text('近7天', style: TextStyle(fontSize: 12))),
        ButtonSegment(value: StatsPeriod.last30Days, label: Text('近30天', style: TextStyle(fontSize: 12))),
        ButtonSegment(value: StatsPeriod.last90Days, label: Text('近90天', style: TextStyle(fontSize: 12))),
        ButtonSegment(value: StatsPeriod.allTime, label: Text('全部', style: TextStyle(fontSize: 12))),
      ],
      selected: {vm.selectedPeriod},
      onSelectionChanged: (s) => vm.setPeriod(s.first),
    );
  }

  Widget _summaryCards(StatsViewModel vm) {
    return Row(
      children: [
        _statCard('记录天数', '${vm.totalEntries}', Icons.calendar_today, Colors.blue),
        const SizedBox(width: 12),
        _statCard('平均心情', vm.averageMoodLabel, Icons.face, Colors.orange),
        const SizedBox(width: 12),
        _statCard('常见心情', vm.mostFrequentMood?.emoji ?? '-', Icons.star, Colors.amber),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: child,
    );
  }

  Widget _trendCard(StatsViewModel vm) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text('趋势分析', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(vm.moodTrend, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
