# Password Manager v1.0.0+1 发布说明

我们很高兴地宣布 Password Manager 密码管理器的第一个正式版本发布！这是一款功能完整、安全可靠的跨平台密码管理应用，基于 Flutter 开发，为用户提供企业级的安全密码管理解决方案。

## 🎉 版本亮点

### 🔐 九种密码类型支持

应用支持管理 9 种不同类型的密码条目：

- **登录信息** - 用户名、密码、邮箱、网址
- **信用卡** - 卡号、持卡人、有效期、CVV、PIN 码
- **身份标识** - 姓名、身份证、电话、地址
- **服务器** - 服务器地址、端口、协议、凭据
- **数据库** - 连接信息、数据库名、连接字符串
- **安全设备** - 设备信息、序列号、MAC 地址
- **WiFi 密码** - SSID、密码、加密方式、频段
- **安全笔记** - 纯文本内容
- **软件许可证** - 产品名、许可证密钥、购买信息

### 🛡️ 企业级安全特性

- **AES-256 ECB 加密** - 对敏感数据进行企业级加密保护
- **生物识别认证** - 支持指纹、Face ID、Touch ID 快速解锁
- **本地安全存储** - 使用 Flutter Secure Storage 安全存储密码
- **自动锁定机制** - 5 分钟闲置后自动锁定应用
- **智能字段加密** - 根据密码类型智能加密对应敏感字段

### 🖥️ 桌面端优化体验

- **系统托盘集成** - 最小化到系统托盘后台运行
- **窗口管理** - 智能窗口控制，防止意外关闭
- **状态指示** - 托盘图标实时显示锁定/解锁状态
- **快捷操作** - 托盘菜单提供快速访问功能

### 🎨 现代化界面设计

- **Material Design 3** - 遵循最新设计规范
- **统一色彩系统** - 采用 #2196F3 主色的渐变设计
- **分类筛选** - 侧边栏分类导航，智能统计显示
- **搜索功能** - 多字段智能搜索快速查找
- **动画效果** - 流畅的交互动画体验

## 🚀 技术特性

### 架构设计

- **分层架构** - 清晰的代码分层（表现层、数据层、工具层）
- **Repository 模式** - 数据访问层抽象
- **Provider 状态管理** - 基于官方推荐的状态管理方案
- **单例模式** - 加密工具和认证服务采用单例模式

### 技术栈

- **前端框架**: Flutter 3.8.1+
- **开发语言**: Dart 3.0+
- **状态管理**: Provider 6.1.5
- **数据持久化**: SharedPreferences + Flutter Secure Storage
- **加密算法**: AES-256 ECB
- **生物识别**: Local Auth 2.3.0
- **桌面集成**: Window Manager + Tray Manager

## 📦 支持平台

应用支持以下所有主要平台：

- **Windows** 10 及以上版本
- **macOS** 10.14 及以上版本
- **Linux** (Ubuntu 18.04+ 等主流发行版)
- **Android** 5.0 (API 21) 及以上版本
- **iOS** 11.0 及以上版本
- **Web** 浏览器 (Chrome、Firefox、Safari 等)

## 🛠️ 实用工具

- **密码生成器** - 安全随机密码生成
- **标签系统** - 灵活的标签管理
- **数据导入导出** - 支持常见格式
- **备份恢复** - 数据安全保障

## 📋 系统要求

### 桌面端

- Windows 10+ / macOS 10.14+ / Linux (Ubuntu 18.04+)
- 至少 2GB RAM
- 至少 100MB 可用磁盘空间

### 移动端

- Android 5.0+ (API 21+) / iOS 11.0+
- 至少 1GB RAM
- 至少 50MB 可用存储空间

## 🚀 安装方式

### Windows

下载 password_manager-windows-1.0.0+1-setup.exe 安装程序，双击运行并按照提示完成安装。

### macOS

下载 password_manager-macos-1.0.0+1.dmg 镜像文件，双击打开并拖拽应用到 Applications 文件夹。

### Linux

下载 password_manager-linux-1.0.0+1.tar.gz 压缩包，解压后运行可执行文件。

### Android

下载 password_manager-android-1.0.0+1.apk 文件，点击安装即可。

### iOS

通过 App Store 下载安装（即将上线）。

### Web

访问 https://password-manager.v8en.com 在线使用。

## 🔧 使用指南

### 首次使用

1. 启动应用后设置生物识别认证或密码
2. 点击主界面的"添加密码"按钮
3. 选择合适的密码类型
4. 填写相应的字段信息
5. 敏感字段将自动加密存储

### 日常操作

- 使用侧边栏按类型筛选密码
- 在搜索框中输入关键词快速查找
- 为密码添加标签便于组织
- 使用内置生成器创建安全密码
- 最小化到托盘后台运行

## 📄 版权信息

**Copyright (c) 2024 V8EN**

- **组织**: V8EN
- **网址**: https://v8en.com
- **作者**: Simon
- **联系方式**: 582883825@qq.com

本项目由 V8EN 组织开发，采用 MIT 许可证发布。

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

**开发者**: Simon | **组织**: V8EN | **官网**: https://v8en.com
