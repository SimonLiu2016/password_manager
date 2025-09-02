# 🔐 密码管理器 (Password Manager)

一个功能完整、安全可靠的跨平台密码管理应用，基于 Flutter 开发，支持 **9 种不同类型的密码条目**，具备企业级安全加密、生物识别认证、系统托盘集成等高级功能。

![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android%20%7C%20iOS%20%7C%20Web-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)

## ✨ 功能特性

### 🔒 多类型密码支持

- **登录信息** - 用户名、密码、邮箱、网址
- **信用卡** - 卡号、持卡人、有效期、CVV、PIN 码
- **身份标识** - 姓名、身份证、电话、地址
- **服务器** - 服务器地址、端口、协议、凭据
- **数据库** - 连接信息、数据库名、连接字符串
- **安全设备** - 设备信息、序列号、MAC 地址
- **WiFi 密码** - SSID、密码、加密方式、频段
- **安全笔记** - 纯文本内容
- **软件许可证** - 产品名、许可证密钥、购买信息

### 🛡️ 安全特性

- **AES-256 ECB 加密** - 企业级加密标准
- **生物识别认证** - 指纹/Face ID/Touch ID 支持
- **本地安全存储** - Flutter Secure Storage
- **自动锁定** - 5 分钟闲置后自动锁定
- **敏感字段加密** - 根据类型智能加密对应字段

### 🖥️ 桌面体验

- **系统托盘集成** - 最小化到托盘运行
- **窗口管理** - 防止意外关闭，智能窗口控制
- **状态指示** - 托盘图标显示锁定/解锁状态
- **快捷操作** - 托盘菜单提供快速访问

### 🎨 现代化界面

- **Material Design 3** - 遵循最新设计规范
- **统一色彩系统** - 主色 #2196F3，渐变设计
- **分类筛选** - 侧边栏分类导航，智能统计
- **搜索功能** - 多字段智能搜索
- **动画效果** - 流畅的交互动画体验

### 🔧 实用工具

- **密码生成器** - 安全随机密码生成
- **标签系统** - 灵活的标签管理
- **数据导入导出** - 支持常见格式
- **备份恢复** - 数据安全保障

## 🏗️ 技术架构

### 架构设计

- **分层架构 (Layered Architecture)** - 清晰的代码分层
- **Repository 模式** - 数据访问层抽象
- **Provider 状态管理** - 基于官方推荐方案
- **单例模式** - 加密工具和认证服务

### 技术栈

- **前端框架**: Flutter 3.8.1+
- **开发语言**: Dart 3.0+
- **状态管理**: Provider 6.1.5
- **数据持久化**: SharedPreferences + Flutter Secure Storage
- **加密算法**: AES-256 ECB
- **生物识别**: Local Auth
- **桌面集成**: Window Manager + Tray Manager

## 📁 项目结构

```
password_manager/
├── lib/
│   ├── app/                    # 应用配置层
│   │   ├── app_theme.dart      # Material 3 主题系统
│   │   ├── theme.dart          # 备用主题配置
│   │   └── theme_2.dart        # 扩展主题配置
│   ├── data/                   # 数据层
│   │   ├── models/
│   │   │   └── password_entry.dart    # 多类型密码实体模型
│   │   └── repositories/
│   │       └── password_repository.dart    # 数据仓库实现
│   ├── presentation/           # 表现层
│   │   ├── components/         # 通用组件
│   │   │   ├── authentication/
│   │   │   │   └── auth_service.dart     # 生物识别认证
│   │   │   ├── navigator_key_holder.dart
│   │   │   └── password_window_listener.dart
│   │   ├── providers/          # 状态管理
│   │   │   ├── auth_provider.dart        # 认证状态
│   │   │   └── password_provider.dart    # 密码数据管理
│   │   └── screens/            # 页面
│   │       ├── add_password_screen.dart  # 添加密码 (9种类型)
│   │       ├── lock_screen.dart         # 锁屏页面
│   │       ├── main_screen.dart         # 主界面
│   │       ├── password_details.dart    # 密码详情
│   │       ├── password_generator.dart  # 密码生成器
│   │       ├── sidebar.dart            # 侧边栏导航
│   │       └── vault_list.dart         # 密码列表
│   ├── utils/                  # 工具层
│   │   ├── constants/
│   │   │   └── system_constants.dart
│   │   └── helpers/
│   │       └── encryption_util.dart   # AES-256 加密工具
│   └── main.dart              # 应用入口
├── android/                   # Android 平台
├── ios/                       # iOS 平台
├── linux/                     # Linux 平台
├── macos/                     # macOS 平台
├── web/                       # Web 平台
├── windows/                   # Windows 平台
├── pubspec.yaml              # 依赖配置
└── README.md                 # 项目说明
```

## 🚀 快速开始

### 环境要求

- **Flutter SDK**: 3.8.1 或更高版本
- **Dart SDK**: 3.0 或更高版本
- **IDE**: VS Code / Android Studio / IntelliJ IDEA
- **平台要求**:
  - Windows 10+ / macOS 10.14+ / Linux (Ubuntu 18.04+)
  - Android 5.0+ (API 21+) / iOS 11.0+

### 安装步骤

1. **克隆项目**

   ```bash
   git clone <repository-url>
   cd password_manager
   ```

2. **安装依赖**

   ```bash
   flutter pub get
   ```

3. **检查环境**

   ```bash
   flutter doctor
   ```

4. **运行应用**

   ```bash
   # 桌面端 (推荐)
   flutter run -d windows   # Windows
   flutter run -d macos     # macOS
   flutter run -d linux     # Linux

   # 移动端
   flutter run -d android   # Android
   flutter run -d ios       # iOS

   # Web端
   flutter run -d chrome    # Web
   ```

### 构建发布版本

```bash
# 桌面端
flutter build windows --release
flutter build macos --release
flutter build linux --release

# 移动端
flutter build apk --release           # Android APK
flutter build appbundle --release     # Android App Bundle
flutter build ios --release           # iOS

# Web端
flutter build web --release
```

## 📦 构建与安装指南

有关详细的构建和安装说明，请参阅以下文档：

- [构建指南](docs/guides/build-guide.md) - 一键打包 Windows 和 macOS 版本的详细说明
- [安装程序指南](docs/guides/installer-guide.md) - 创建专业安装程序(.exe/.dmg)的详细说明
- [GitHub Actions 指南](docs/guides/github-actions-guide.md) - CI/CD 自动化构建配置说明

## 📦 依赖包

### 核心依赖

```
dependencies:
  flutter_secure_storage: ^9.2.4 # 安全存储
  local_auth: ^2.3.0 # 生物识别认证
  encrypt: ^5.0.3 # 加密工具
  provider: ^6.1.5 # 状态管理
  shared_preferences: ^2.5.3 # 数据持久化
  window_manager: ^0.5.0 # 桌面窗口管理
  tray_manager: ^0.5.0 # 系统托盘
  bot_toast: ^4.0.1 # 消息提示
  path_provider: ^2.1.5 # 路径获取
  flutter_local_notifications: ^19.3.0 # 本地通知
  app_links: ^6.3.3 # 应用链接
```

## 🎯 使用指南

### 基本操作

1. **首次启动**: 设置生物识别认证或密码
2. **添加密码**: 点击主界面的"添加密码"按钮
3. **选择类型**: 从 9 种类型中选择合适的密码类型
4. **填写信息**: 根据类型填写相应的字段
5. **保存密码**: 敏感字段将自动加密存储

### 高级功能

- **分类筛选**: 使用侧边栏按类型筛选密码
- **搜索功能**: 在搜索框中输入关键词快速查找
- **标签管理**: 为密码添加标签便于组织
- **密码生成**: 使用内置生成器创建安全密码
- **系统托盘**: 最小化到托盘后台运行

### 安全提示

- 应用会在闲置 5 分钟后自动锁定
- 所有敏感数据均使用 AES-256 加密
- 支持生物识别快速解锁
- 建议定期备份密码数据

## 🔧 开发指南

### 代码规范

项目遵循以下开发规范：

- **架构模式**: MVVM + Repository Pattern
- **状态管理**: Provider 模式
- **代码风格**: Dart 官方规范 + Flutter Lints
- **加密标准**: AES-256 ECB 模式

### 添加新的密码类型

1. 在 `PasswordEntryType` 枚举中添加新类型
2. 在 `PasswordEntryTypeConfig` 中配置字段定义
3. 更新加密逻辑处理新的敏感字段
4. 在 UI 中添加对应的图标和样式

### 自定义主题

修改 `lib/app/app_theme.dart` 文件中的颜色和样式定义。

## 🐛 问题排查

### 常见问题

1. **生物识别不可用**

   - 检查设备是否支持生物识别
   - 确认已在系统设置中启用

2. **数据丢失**

   - 检查应用权限设置
   - 查看是否有备份文件

3. **窗口管理问题**
   - 确保运行在支持的桌面环境
   - 检查窗口管理器权限

### 获取帮助

如果遇到问题，请：

1. 查看应用日志
2. 检查 `flutter doctor` 输出
3. 查阅项目文档
4. 提交 Issue 报告

## 🤝 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 项目
2. 创建功能分支: `git checkout -b feature/new-feature`
3. 提交更改: `git commit -am 'Add new feature'`
4. 推送分支: `git push origin feature/new-feature`
5. 提交 Pull Request

### 贡献规范

- 代码需要通过所有测试
- 遵循项目的代码风格
- 添加必要的文档和注释
- 更新相关的测试用例

## 📄 版权信息

**Copyright (c) 2024 V8EN**

- **组织**: V8EN
- **网址**: https://v8en.com
- **作者**: Simon
- **联系方式**: 582883825@qq.com

本项目由 V8EN 组织开发，保留所有权利。

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

感谢以下开源项目的支持：

- [Flutter](https://flutter.dev/) - 跨平台框架
- [Provider](https://pub.dev/packages/provider) - 状态管理
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) - 安全存储
- [Local Auth](https://pub.dev/packages/local_auth) - 生物识别
- [Encrypt](https://pub.dev/packages/encrypt) - 加密库

---

**⭐ 如果这个项目对您有帮助，请给个 Star！**

**🔐 让密码管理变得简单而安全！**

---

**开发者**: Simon | **组织**: V8EN | **官网**: https://v8en.com
