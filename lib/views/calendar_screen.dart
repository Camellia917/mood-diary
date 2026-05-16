import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/calendar_viewmodel.dart';

import 'day_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarViewModel>().loadMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _monthNav(vm),
                _weekdayHeader(),
                _calendarGrid(vm),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _monthNav(CalendarViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: vm.goToPreviousMonth,
          ),
          Text(vm.monthTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: vm.goToNextMonth,
          ),
        ],
      ),
    );
  }

  Widget _weekdayHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: ['一', '二', '三', '四', '五', '六', '日']
            .map((s) => Expanded(
                  child: Center(
                    child: Text(s,
                        style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _calendarGrid(CalendarViewModel vm) {
    final days = vm.daysInMonth();
    final rows = (days.length / 7).ceil();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: List.generate(rows, (row) {
            return Expanded(
              child: Row(
                children: List.generate(7, (col) {
                  final idx = row * 7 + col;
                  if (idx >= days.length || days[idx] == null) {
                    return const Expanded(child: SizedBox());
                  }
                  final date = days[idx]!;
                  final key = DateFormat('yyyy-MM-dd').format(date);
                  final entry = vm.entries[key];
                  final today = vm.isToday(date);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        vm.selectDate(date);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: vm,
                              child: DayDetailScreen(date: date, entry: entry),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: today
                              ? Theme.of(context).colorScheme.primary
                              : entry != null
                                  ? entry.mood.color.withValues(alpha: 0.7)
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: today ? FontWeight.bold : FontWeight.normal,
                                color: today || entry != null ? Colors.white : Colors.black87,
                              ),
                            ),
                            if (entry != null)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white70),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}
