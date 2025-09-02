# Password Manager 专业安装程序创建指南

## 概述

为了提供更好的用户体验，项目提供了专业安装程序创建脚本 [create_installer.sh](create_installer.sh)，可以为不同平台创建标准的安装程序：

- Windows: .exe 安装程序
- macOS: .dmg 磁盘映像
- Linux: 安装脚本

## 使用方法

### 1. 准备工作

在创建安装程序之前，请确保已完成应用的构建：

```bash
# 构建所有平台
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

### 2. 运行安装程序创建脚本

```bash
# 进入项目目录
cd /Users/simon/Workspace/vsProject/password_manager

# 给脚本添加执行权限（如果尚未添加）
chmod +x create_installer.sh

# 运行脚本
./create_installer.sh
```

### 3. 各平台详细说明

#### macOS (.dmg)

脚本会自动检查并安装 `create-dmg` 工具（需要 Homebrew），然后创建标准的 DMG 安装程序。

输出文件：`build/installer/password_manager-macos-{version}.dmg`

#### Windows (.exe)

需要预先安装 Inno Setup，脚本会使用 Inno Setup 编译器创建安装程序。

输出文件：`build/installer/password_manager-windows-{version}-setup.exe`

#### Linux (安装脚本)

创建一个简单的安装脚本，用户可以通过该脚本将应用安装到系统中。

输出文件：`build/installer/install-password-manager.sh`

## 依赖工具

### macOS

- Homebrew (用于安装 create-dmg)
- create-dmg 工具

### Windows

- Inno Setup (用于创建 .exe 安装程序)

### Linux

- 无特殊依赖

## 自定义配置

如果需要自定义安装程序的外观或行为，可以修改 [create_installer.sh](create_installer.sh) 脚本中的相应部分：

1. macOS DMG 的窗口大小、位置和样式
2. Windows Inno Setup 脚本的配置选项
3. Linux 安装脚本的行为

## 故障排除

### macOS

如果遇到 DMG 创建问题，请手动安装 create-dmg：

```bash
brew install create-dmg
```

### Windows

如果遇到 Inno Setup 问题，请安装 Inno Setup：

- 访问官网下载：https://jrsoftware.org/isinfo.php
- 或使用 Chocolatey 安装：`choco install innosetup`

### Linux

确保运行安装脚本时具有适当的权限：

```bash
sudo ./install-password-manager.sh
```

## 输出位置

所有安装程序都会生成在以下目录：
`build/installer/`

## 注意事项

1. 创建安装程序前必须先完成相应平台的构建
2. 某些平台的安装程序创建需要管理员权限
3. 专业安装程序提供更好的用户体验，包括开始菜单项、桌面图标等
4. 安装程序会自动处理应用的注册表项（Windows）或系统集成（macOS/Linux）
