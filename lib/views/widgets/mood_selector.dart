import 'package:flutter/material.dart';
import '../../models/mood_type.dart';

class MoodSelector extends StatelessWidget {
  final MoodType? selected;
  final ValueChanged<MoodType> onChanged;
  final bool disabled;

  const MoodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: MoodType.values.map((mood) {
        final isSelected = selected == mood;
        return _MoodButton(
          mood: mood,
          isSelected: isSelected,
          onTap: () {
            if (!disabled) onChanged(mood);
          },
        );
      }).toList(),
    );
  }
}

class _MoodButton extends StatelessWidget {
  final MoodType mood;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodButton({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isSelected ? 60 : 52,
              height: isSelected ? 60 : 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? mood.color : mood.color.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Text(
                  mood.emoji,
                  style: TextStyle(fontSize: isSelected ? 28 : 24),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              mood.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? mood.color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
