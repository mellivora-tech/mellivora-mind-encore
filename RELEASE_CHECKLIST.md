# Encore — TestFlight / Release 发布核对清单

## 前置条件

- [ ] Apple Developer Account 已激活
- [ ] Google Play Console 已创建应用
- [ ] Flutter SDK >= 3.19.0 已安装

## iOS — TestFlight 发布

### 1. Xcode 项目配置
- [ ] 打开 `ios/Runner.xcworkspace`
- [ ] 设置 Bundle Identifier: `com.mellivora.encore`
- [ ] 设置 Team ID（Apple Developer 团队）
- [ ] 确认 Deployment Target: iOS 16.0
- [ ] 启用 Background Modes: Audio, Background Fetch, Background Processing
- [ ] 添加 Share Extension target（参考 `ios/ShareExtension/`）
- [ ] 配置 App Groups（主 App + Share Extension 共享数据）

### 2. 签名证书
- [ ] 创建 Distribution Certificate（Apple Developer Portal）
- [ ] 创建 App Store Provisioning Profile
- [ ] 在 Xcode 中选择正确的 Provisioning Profile

### 3. 环境变量
- [ ] 创建 `.env` 文件，配置:
  - `OPENAI_API_KEY` — OpenAI API 密钥
  - `WHISPER_API_URL` — Whisper 转录服务地址

### 4. 构建 & 上传
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```
- [ ] 使用 Transporter 或 `xcrun altool` 上传到 App Store Connect
- [ ] 在 App Store Connect 中添加测试员
- [ ] 提交 TestFlight 审核

## Android — APK / Play Store 发布

### 1. 签名密钥
```bash
keytool -genkey -v -keystore mellivora-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias mellivora
```
- [ ] 将生成的 `.jks` 文件放到 `android/` 目录
- [ ] 复制 `android/key.properties.template` 为 `android/key.properties`
- [ ] 填写真实密码（此文件已在 .gitignore 中）

### 2. 构建
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build apk --release --split-per-abi
# 或 App Bundle:
flutter build appbundle --release
```

### 3. 发布
- [ ] 上传至 Google Play Console
- [ ] 填写应用信息、截图、隐私政策
- [ ] 提交审核

## CI/CD（GitHub Actions）

### Secrets 配置
| Secret 名称 | 用途 |
|---|---|
| `APPLE_CERT` | iOS 分发证书 (.p12 base64) |
| `APPLE_PROFILE` | iOS Provisioning Profile (base64) |
| `APPLE_TEAM_ID` | Apple 团队 ID |
| `KEYSTORE_BASE64` | Android 签名密钥 (base64) |
| `KEYSTORE_PASSWORD` | Keystore 密码 |
| `KEY_ALIAS` | Key alias |
| `KEY_PASSWORD` | Key 密码 |

- [ ] 在 GitHub repo Settings → Secrets 中配置以上 Secrets
- [ ] 手动触发 `build-ios.yml` / `build-android.yml` 验证构建
