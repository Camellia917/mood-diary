# CLAUDE.md — 心情日记 Flutter App

## 项目概述

心情日记是跨平台日记应用（Android + iOS），Flutter + sqflite + Provider 构建。帮助用户记录每日情绪并通过可视化图表跟踪趋势。纯本地存储，中文界面。

## 标准文件路径

| 文档 | 路径 | 何时查阅 |
|------|------|---------|
| 需求文档 | `docs/requirements.md` | 理解功能范围、情绪定义 |
| 技术规范 | `docs/tech-spec.md` | 技术栈、数据模型、架构 |
| 设计规范 | `docs/design-spec.md` | UI 布局、配色、组件规范 |
| 实施步骤 | `docs/implementation-steps.md` | 当前进度、阶段规划 |
| 开发日志 | `devlogs/` | 每日开发记录 |

## 技术要点

```dart
// 架构
View (Screen) → ViewModel (ChangeNotifier) → Service (Singleton) → sqflite

// 数据
MoodType: enum { veryBad(1), bad(2), neutral(3), good(4), veryGood(5) }
MoodEntry: { id, date, moodValue, note?, createdAt, updatedAt }

// 关键单例
DatabaseService()    // sqflite 数据库
NotificationService() // 本地通知

// 依赖
provider, sqflite, fl_chart, flutter_local_notifications, intl, timezone
```

## 工作流程

### 每次会话开始
1. 浏览 `devlogs/` 最新日志了解当前进度
2. 阅读 `docs/implementation-steps.md` 确认未完成事项
3. 有新任务先判断是否需要计划模式

### 计划模式判定
- **需计划**：新增功能模块、修改数据模型、涉及 3+ 文件改动
- **跳过**：修 Bug、改文案、UI 微调、单文件改动

### 修改代码时
1. 遵循 MVVM：Model → Service → ViewModel → View
2. ViewModel 使用 `ChangeNotifier`，View 用 `Consumer` 监听
3. 新页面添加到 `lib/views/`，新组件放 `lib/views/widgets/`
4. 数据库变更需更新 `database_service.dart`

### 验证
- `flutter analyze` — 静态检查（每次改动后必跑）
- `flutter run` — 启动 App 到模拟器/真机
- `flutter build apk --debug` — 构建 Android 安装包

## 项目状态

- **阶段 1 完成**：全部 Dart 代码通过 flutter analyze（0 issues）
- **待做**：JDK 配置 → Android 构建 → 真机/模拟器测试
- **项目位置**：`c:/Users/黄金秋/xinqingriji/`
