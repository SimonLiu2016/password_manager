# 密码管理器多类型支持实现方案

## 📋 项目概述

根据您的需求，我已经重新设计了密码管理器的数据模型，使其支持多种类型的密码条目，每种类型都有其特有的字段结构。

## 🎯 核心改进内容

### 1. 新的数据模型设计

#### PasswordEntry 类重构

- **灵活的字段存储**：使用 `Map<String, dynamic> fields` 存储各种类型的特有字段
- **标签系统**：添加 `List<String> tags` 支持标签分类
- **便捷访问**：提供 getter 方法快速访问常用字段（username、password、url 等）

#### 支持的类型（9 种）

1. **登录信息** (login) - 用户名、密码、邮箱、网址
2. **信用卡** (creditCard) - 卡号、持卡人姓名、有效期、CVV、PIN 码
3. **身份标识** (identity) - 姓名、身份证号、电话、邮箱、地址
4. **服务器** (server) - 服务器地址、端口、用户名、密码、协议
5. **数据库** (database) - 服务器地址、端口、数据库名、用户名、密码、连接字符串
6. **安全设备** (device) - 设备名称、设备类型、用户名、密码、序列号、MAC 地址
7. **WiFi 密码** (wifi) - SSID、密码、加密方式、频段
8. **安全笔记** (secureNote) - 内容
9. **软件许可证** (license) - 产品名称、许可证密钥、版本、注册邮箱、购买日期、到期日期

### 2. 类型配置系统

#### PasswordEntryTypeConfig 类

- **统一配置管理**：每种类型的名称、图标、颜色、字段定义
- **字段类型支持**：text、password、email、url、phone、number、textarea、date
- **验证规则**：必填字段标记和验证逻辑

### 3. 界面重构

#### 添加密码页面 (AddPasswordScreen)

- **类型选择器**：网格布局显示所有类型，支持动画选择效果
- **动态字段生成**：根据选择的类型自动生成对应的输入字段
- **标签管理**：支持添加/删除标签，实时预览
- **智能密码生成器**：只在有密码字段的类型中显示

#### 字段类型支持

- **文本字段**：基础文本输入
- **密码字段**：支持显示/隐藏，复制功能
- **邮箱字段**：邮箱键盘类型
- **网址字段**：URL 键盘类型
- **电话字段**：数字键盘类型
- **数字字段**：纯数字输入
- **多行文本**：支持大段文本输入
- **日期字段**：日期选择器

## 🔧 技术特性

### 数据兼容性

- **向后兼容**：新模型通过 fromMap 方法支持旧数据格式
- **数据迁移**：自动处理字段为空的情况
- **错误处理**：优雅处理数据解析失败

### UI/UX 设计

- **统一色彩系统**：每种类型有独特的主题色（遵循规范：主色#2196F3）
- **现代化图标**：为每种类型配置专门的图标
- **动画效果**：类型选择、字段切换等都有流畅动画
- **响应式布局**：适配不同屏幕尺寸

### 扩展性

- **易于添加新类型**：只需在配置中添加新的类型定义
- **字段类型可扩展**：支持添加新的输入类型
- **验证规则灵活**：基于配置的表单验证

## 📁 已完成的文件

### ✅ 数据模型

- `lib/data/models/password_entry.dart` - 完全重构，支持多类型

### ✅ 界面页面

- `lib/presentation/screens/add_password_screen.dart` - 完全重构，支持类型选择和动态字段

## 🔄 待更新的文件

为了完整支持新的数据模型，还需要更新以下文件：

### 🔧 数据层

- `lib/data/repositories/password_repository.dart` - 适配新的字段结构
- `lib/data/storage/password_storage.dart` - 更新加密存储逻辑

### 🖼️ 界面层

- `lib/presentation/screens/password_details.dart` - 支持多类型字段显示和编辑
- `lib/presentation/screens/vault_list.dart` - 显示不同类型的图标和信息
- `lib/presentation/providers/password_provider.dart` - 适配新的数据结构

## 🚀 实现建议

### 阶段 1：数据层修复

1. 更新 PasswordRepository 使用新的字段访问方式
2. 修复所有编译错误
3. 实现数据迁移逻辑

### 阶段 2：界面适配

1. 更新密码详情页面支持动态字段显示
2. 更新密码列表显示类型图标和信息
3. 优化搜索功能支持多字段搜索

### 阶段 3：功能增强

1. 添加类型筛选功能
2. 实现标签管理页面
3. 添加数据导入/导出功能

## 💡 使用示例

### 创建数据库类型条目

```dart
final dbEntry = PasswordEntry(
  id: '123',
  title: '生产数据库',
  type: PasswordEntryType.database,
  fields: {
    'serverAddress': '192.168.1.100',
    'port': '3306',
    'databaseName': 'production_db',
    'username': 'admin',
    'password': 'encrypted_password',
    'connectionString': 'mysql://admin:pwd@192.168.1.100:3306/production_db',
  },
  tags: ['生产环境', '重要'],
  notes: '主要业务数据库，需要定期备份',
);
```

### 访问特定字段

```dart
print(dbEntry.serverAddress);  // 192.168.1.100
print(dbEntry.databaseName);   // production_db
print(dbEntry.tags);           // ['生产环境', '重要']
```

## 🎯 预期效果

完成后，用户将能够：

- 选择 9 种不同类型的密码条目
- 每种类型显示相应的输入字段
- 使用标签系统组织密码
- 享受现代化的用户界面
- 获得类型特定的功能（如信用卡有效期提醒等）

这个设计提供了强大的扩展性和用户友好的体验，完全满足您提出的需求！
