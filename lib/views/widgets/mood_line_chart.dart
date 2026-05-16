import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/mood_entry.dart';

class MoodLineChart extends StatelessWidget {
  final List<MoodEntry> data;

  const MoodLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.show_chart, size: 16, color: Colors.grey),
            SizedBox(width: 6),
            Text('情绪趋势', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 12),
        if (data.isEmpty)
          _emptyView
        else
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final labels = ['', '😫', '😔', '😐', '😊', '🥳'];
                        final i = value.toInt();
                        if (i >= 1 && i <= 5) {
                          return Text(labels[i], style: const TextStyle(fontSize: 12));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: (data.length / 4).ceilToDouble().clamp(1, 999),
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i >= 0 && i < data.length && i % ((data.length / 4).ceil()) == 0) {
                          return Text(
                            DateFormat('M/d', 'zh_CN').format(data[i].date),
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: 0.5,
                maxY: 5.5,
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.moodValue.toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        final mood = data[index].mood;
                        return FlDotCirclePainter(radius: 3.5, color: mood.color, strokeWidth: 0);
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blueAccent.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
