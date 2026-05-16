import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/today_viewmodel.dart';
import '../services/feedback_service.dart';
import 'widgets/mood_selector.dart';
import 'widgets/diary_editor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodayViewModel>().loadToday();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodayViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _dateHeader(vm),
                  const SizedBox(height: 28),
                  if (!vm.isSaved) ...[
                    _recordSection(vm),
                  ] else ...[
                    _savedSection(vm),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dateHeader(TodayViewModel vm) {
    return Column(
      children: [
        Text(vm.todayDateString, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 8),
        const Text('今天心情如何？', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _recordSection(TodayViewModel vm) {
    return Column(
      children: [
        MoodSelector(
          selected: vm.selectedMood,
          onChanged: vm.selectMood,
        ),
        const SizedBox(height: 24),
        DiaryEditor(
          note: vm.note,
          onChanged: vm.setNote,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton(
            onPressed: vm.selectedMood != null ? vm.saveMood : null,
            style: FilledButton.styleFrom(
              backgroundColor: vm.selectedMood != null ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 20),
                SizedBox(width: 8),
                Text('记录今日心情', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _savedSection(TodayViewModel vm) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 18),
              SizedBox(width: 6),
              Text('今日心情已记录', style: TextStyle(color: Colors.green, fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _moodDisplay(vm),
        const SizedBox(height: 24),
        _feedbackCard(vm),
        if (vm.todayEntry?.note?.isNotEmpty == true) ...[
          const SizedBox(height: 16),
          _diaryCard(vm),
        ],
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: vm.startEditing,
          icon: const Icon(Icons.edit, size: 18),
          label: const Text('修改今日记录'),
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _moodDisplay(TodayViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: vm.selectedMood?.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(vm.selectedMood?.emoji ?? '', style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 8),
          Text(
            vm.selectedMood?.label ?? '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: vm.selectedMood?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackCard(TodayViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.chat_bubble_outline, size: 16, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 6),
              Text('心情反馈',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary)),
            ],
          ),
          const SizedBox(height: 10),
          Text(vm.feedbackText,
              style: const TextStyle(fontSize: 15, height: 1.6)),
          const Divider(height: 24),
          Text(FeedbackService.encouragingTip(),
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _diaryCard(TodayViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.book, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text('今日日记', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          Text(vm.todayEntry?.note ?? '',
              style: const TextStyle(fontSize: 15, height: 1.6)),
        ],
      ),
    );
  }
}
