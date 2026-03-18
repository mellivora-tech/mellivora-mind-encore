# mellivora-english-app

> 像听音乐一样学英语 🎵

一款以「沉浸式音频」为核心的英语学习 Flutter APP。上传音频/播客，自动生成带时间戳字幕，AI 智能分章节，让你在听的过程中随时查词、复习重点片段。

---

## 产品定位

| 痛点 | 解法 |
|---|---|
| 传统学习枯燥，坚持不下去 | 听自己感兴趣的英语内容 |
| 听不懂但没有字幕 | Whisper API 自动转录 + 实时字幕高亮 |
| 长音频难以复习重点 | AI 自动切章节，随时跳回 |
| 遇到生词打断听的节奏 | 点词查词，不离开播放界面 |

---

## 技术栈

| 模块 | 技术 |
|---|---|
| 跨平台框架 | [Flutter](https://flutter.dev) (iOS + Android) |
| 音频播放 | [just_audio](https://pub.dev/packages/just_audio) + [audio_service](https://pub.dev/packages/audio_service) |
| 语音转录 | [OpenAI Whisper API](https://platform.openai.com/docs/guides/speech-to-text)（verbose_json，带时间戳） |
| 本地存储 | SQLite（[sqflite](https://pub.dev/packages/sqflite)） |
| 状态管理 | Riverpod |
| AI 查词 | LLM API（GPT-4o-mini） |

---

## 核心功能（规划中）

- 🎧 **音频播放器** — 后台播放、变速、循环单章节
- 📝 **实时字幕** — 根据时间戳高亮当前句，CC 悬浮标控制显隐
- 📚 **智能章节** — AI 自动将音频切为 30-60s 章节，生成标题
- 🔍 **点词查词** — 点击字幕中任意词，弹出 LLM 释义卡片
- 🔁 **章节循环** — 难点片段单独循环练习

---

## 目录结构

```
mellivora-english-app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/                  # 基础设施
│   │   ├── database/          # SQLite 数据层
│   │   ├── network/           # API 客户端（Whisper/LLM）
│   │   └── utils/
│   ├── features/
│   │   ├── player/            # 播放器（音频 + 字幕同步）
│   │   ├── chapters/          # 章节管理
│   │   ├── transcript/        # 转录任务
│   │   └── vocabulary/        # 查词记录
│   └── shared/                # 通用 UI 组件
├── assets/
│   ├── audio/                 # 测试音频
│   └── icons/
├── test/
│   ├── unit/
│   └── widget/
├── android/
├── ios/
├── pubspec.yaml
└── README.md
```

---

## 开发状态

> ⚠️ **PRD 撰写中**，功能开发尚未启动。仓库当前仅完成基础结构搭建。

---

## 本地运行（待更新）

```bash
# 安装依赖
flutter pub get

# 运行
flutter run
```

---

## License

MIT
