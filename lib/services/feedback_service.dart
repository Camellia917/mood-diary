import 'dart:math';
import '../models/mood_type.dart';

class FeedbackService {
  static String feedbackFor(MoodType mood) => mood.feedbackText;

  static String encouragingTip() {
    final tips = [
      '记得深呼吸，给自己一个微笑 🌿',
      '今天喝够水了吗？照顾好自己哦 💧',
      '伸个懒腰，让身体放松一下吧 🧘',
      '写下三件让你感激的小事吧 ✍️',
      '出去走一走，感受一下外面的空气 🚶',
      '给自己泡一杯热茶或咖啡吧 ☕',
      '听一首喜欢的歌，让心情跟着旋律飘一会儿 🎵',
    ];
    return tips[Random().nextInt(tips.length)];
  }
}
