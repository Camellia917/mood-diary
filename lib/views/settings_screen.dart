import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('设置')),
          body: ListView(
            children: [
              _sectionHeader('通知'),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('每日提醒'),
                subtitle: const Text('开启后，将在每天设定时间提醒你记录心情'),
                value: vm.reminderEnabled,
                onChanged: (v) => vm.setReminder(v),
              ),
              if (vm.reminderEnabled)
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('提醒时间'),
                  trailing: TextButton(
                    onPressed: () => _pickTime(context, vm),
                    child: Text(
                      '${vm.reminderTime.hour.toString().padLeft(2, '0')}:${vm.reminderTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              const Divider(),
              _sectionHeader('关于'),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('版本'),
                trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  '心情日记 — 记录每一天的情绪，了解更好的自己 ✨',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickTime(BuildContext context, SettingsViewModel vm) async {
    final time = await showTimePicker(
      context: context,
      initialTime: vm.reminderTime,
    );
    if (time != null) {
      vm.setReminderTime(time);
    }
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
    );
  }
}
