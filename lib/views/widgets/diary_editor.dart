import 'package:flutter/material.dart';

class DiaryEditor extends StatelessWidget {
  final String note;
  final ValueChanged<String> onChanged;

  const DiaryEditor({
    super.key,
    required this.note,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.book, size: 16, color: Colors.grey),
            SizedBox(width: 6),
            Text('今日日记', style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 0.5),
          ),
          child: TextField(
            controller: TextEditingController(text: note)
              ..selection = TextSelection.collapsed(offset: note.length),
            onChanged: onChanged,
            maxLines: 5,
            minLines: 3,
            decoration: const InputDecoration(
              hintText: '今天发生了什么？写下来吧...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }
}
