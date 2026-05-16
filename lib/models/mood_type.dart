import 'package:flutter/material.dart';

enum MoodType {
  veryBad(1, '非常差', '😫', Color(0xFFE74C3C)),
  bad(2, '较差', '😔', Color(0xFFF39C12)),
  neutral(3, '一般', '😐', Color(0xFF7F8C8D)),
  good(4, '不错', '😊', Color(0xFF2ECC71)),
  veryGood(5, '很好', '🥳', Color(0xFF3498DB));

  final int value;
  final String label;
  final String emoji;
  final Color color;
  const MoodType(this.value, this.label, this.emoji, this.color);

  static MoodType fromValue(int v) {
    return MoodType.values.firstWhere((m) => m.value == v, orElse: () => neutral);
  }

  String get feedbackText {
    switch (this) {
      case veryBad:
        return "抱抱你 (´•̥̥̥ω•̥̥̥` )\n每个人都会有低谷，给自己一些时间和空间，明天会更好的 🌧️→☀️";
      case bad:
        return "今天可能不太顺利呢 (｡•́︿•̀｡)\n不过没关系，你已经很棒了，好好休息一下吧 💪";
      case neutral:
        return "平平淡淡的一天也很珍贵呢 ✨\n生活中的小确幸往往藏在不经意间～";
      case good:
        return "今天心情不错嘛！(◍•ᴗ•◍)\n继续保持这份好状态，让快乐延续下去吧 🌟";
      case veryGood:
        return "太棒了！🎉\n如此美好的心情值得被记住，希望每一天都这么开心 ٩(◕‿◕｡)۶";
    }
  }
}
