# Password Manager 打包构建说明

## 一键打包脚本使用方法

项目提供了一个自动化构建脚本 [build_release.sh](build_release.sh)，可以一键打包 Windows 和 macOS 两个平台的发布版本。

### 使用步骤

1. 确保您在 macOS 系统上运行（因为需要构建 macOS 版本）
2. 确保已安装 Flutter 开发环境
3. 在终端中执行以下命令：

```bash
# 进入项目目录
cd /Users/simon/Workspace/vsProject/password_manager

# 给脚本添加执行权限（如果尚未添加）
chmod +x build_release.sh

# 运行构建脚本
./build_release.sh
```

### 脚本功能

该脚本会自动完成以下操作：

1. 检查 Flutter 环境
2. 安装项目依赖
3. 运行代码分析
4. 构建 Windows 版本
5. 构建 macOS 版本
6. 将构建产物打包为 ZIP 文件
7. 输出到 `build/release/` 目录

### 输出文件

构建完成后，您将在以下位置找到生成的安装包：

- `build/release/password_manager-windows-{version}.zip`
- `build/release/password_manager-macos-{version}.zip`

### 注意事项

1. Windows 版本构建产物为可直接运行的文件，无需安装程序
2. macOS 版本构建产物为.app 应用程序包
3. 如需创建安装程序（.exe/.msi/.dmg），请使用相应的打包工具处理生成的文件
4. 构建过程可能需要较长时间，请耐心等待

### 自定义构建

如果您只需要构建特定平台，可以使用以下命令：

```bash
# 仅构建Windows版本
flutter build windows --release

# 仅构建macOS版本
flutter build macos --release

# 仅构建Web版本
flutter build web --release

# 仅构建Android版本
flutter build apk --release

# 仅构建iOS版本
flutter build ios --release
```
