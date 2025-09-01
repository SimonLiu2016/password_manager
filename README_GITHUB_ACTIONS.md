# 使用 GitHub Actions 构建安装包

## 概述

本项目配置了 GitHub Actions 工作流，可以自动构建和发布密码管理器的安装包。当您推送标签到仓库时，GitHub Actions 会自动构建 Windows 和 macOS 版本，并创建包含安装包的 GitHub Release。

## 工作流配置

工作流文件位于 [.github/workflows/build-release.yml](.github/workflows/build-release.yml)，包含以下步骤：

1. 检出代码
2. 设置 Flutter 环境
3. 安装项目依赖
4. 运行代码分析
5. 安装构建工具 (create-dmg)
6. 构建 Windows 版本
7. 构建 macOS 版本
8. 创建发布包
9. 创建安装程序
10. 上传构建产物
11. 创建 GitHub Release 并上传安装包

## 使用方法

### 1. 推送标签触发构建

要触发自动构建和发布，请创建并推送一个标签：

```bash
# 创建标签 (例如 v1.0.0+1)
git tag v1.0.0+1

# 推送标签到 GitHub
git push origin v1.0.0+1
```

### 2. 手动触发工作流

您也可以通过 GitHub 网页界面手动触发工作流：

1. 访问您的 GitHub 仓库
2. 点击 "Actions" 标签
3. 选择 "Build and Release Password Manager" 工作流
4. 点击 "Run workflow" 按钮

## 构建产物

构建完成后，GitHub Release 将包含以下安装包：

- Windows ZIP 包 (password_manager-windows-{version}.zip)
- macOS ZIP 包 (password_manager-macos-{version}.zip)
- macOS DMG 安装程序 (password_manager-macos-{version}.dmg)
- Windows EXE 安装程序 (password_manager-windows-{version}-setup.exe)
- Linux 安装脚本 (install-password-manager.sh)

## 配置说明

### Flutter 版本

工作流使用 Flutter 3.24.0 稳定版。如需更改版本，请修改工作流文件中的 `flutter-version` 参数。

### 构建平台

当前工作流配置为在 macOS 运行器上运行，因为需要构建 macOS 版本。Windows 版本也可以在 macOS 上构建，因为 Flutter 支持跨平台构建。

## 故障排除

### 构建失败

如果构建失败，请检查以下几点：

1. 确保 pubspec.yaml 中的依赖项正确
2. 检查代码是否通过分析 (flutter analyze)
3. 确保构建脚本具有执行权限
4. 查看 GitHub Actions 日志以获取详细错误信息

### Release 未创建

如果 GitHub Release 未创建，请确保：

1. 您推送的是标签 (以 v 开头)
2. 工作流具有必要的权限
3. GITHUB_TOKEN 环境变量已正确设置

## 自定义工作流

如果需要自定义构建过程，可以修改 [.github/workflows/build-release.yml](.github/workflows/build-release.yml) 文件：

1. 更改 Flutter 版本
2. 添加其他平台的构建步骤
3. 修改构建产物的文件名格式
4. 添加测试步骤
5. 配置通知

## 权限要求

工作流需要以下权限：

- 读取代码仓库
- 创建 GitHub Release
- 上传构建产物

这些权限由 GitHub Actions 默认提供。