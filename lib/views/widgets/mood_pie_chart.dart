import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/mood_type.dart';

class MoodPieChart extends StatelessWidget {
  final Map<MoodType, int> data;

  const MoodPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<int>(0, (a, b) => a + b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.pie_chart, size: 16, color: Colors.grey),
            SizedBox(width: 6),
            Text('情绪分布', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 12),
        if (total == 0)
          _emptyView
        else
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: MoodType.values.map((mood) {
                  final count = data[mood] ?? 0;
                  final pct = total > 0 ? (count / total * 100).toStringAsFixed(0) : '0';
                  return PieChartSectionData(
                    color: mood.color,
                    value: count.toDouble(),
                    title: count > 0 ? '$pct%' : '',
                    radius: 60,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        if (total > 0) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: MoodType.values.map((mood) {
              final count = data[mood] ?? 0;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: mood.color)),
                  const SizedBox(width: 4),
                  Text('${mood.emoji} $count',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget get _emptyView => const SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📭', style: TextStyle(fontSize: 32)),
              SizedBox(height: 8),
              Text('暂无数据', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
}
