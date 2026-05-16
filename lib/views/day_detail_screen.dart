import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/calendar_viewmodel.dart';
import '../models/mood_entry.dart';
import '../models/mood_type.dart';
import 'widgets/mood_selector.dart';
import 'widgets/diary_editor.dart';

class DayDetailScreen extends StatefulWidget {
  final DateTime date;
  final MoodEntry? entry;

  const DayDetailScreen({super.key, required this.date, required this.entry});

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  MoodType? _selectedMood;
  late String _note;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.entry?.mood;
    _note = widget.entry?.note ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('M月 d日 EEEE', 'zh_CN').format(widget.date)),
        actions: [
          if (widget.entry != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showDeleteConfirm,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            MoodSelector(
              selected: _selectedMood,
              onChanged: (m) {
                setState(() {
                  _selectedMood = m;
                  _hasChanges = true;
                });
              },
            ),
            const SizedBox(height: 24),
            DiaryEditor(
              note: _note,
              onChanged: (v) {
                _note = v;
                _hasChanges = true;
              },
            ),
            if (_hasChanges) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _selectedMood != null ? _save : null,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        _selectedMood != null ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 20),
                      SizedBox(width: 8),
                      Text('保存修改', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _save() {
    final vm = context.read<CalendarViewModel>();
    final cleanNote = _note.trim().isEmpty ? null : _note.trim();
    vm.updateEntry(_selectedMood!.value, cleanNote);
    Navigator.pop(context);
  }

  void _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这天的记录吗？此操作不可撤销。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              context.read<CalendarViewModel>().deleteEntry();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
