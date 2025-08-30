/*
 * Password Manager - App Theme Configuration
 * 
 * Copyright (c) 2024 V8EN (https://v8en.com)
 * Author: Simon <582883825@qq.com>
 * 
 * This file contains the theme configuration for the Password Manager application.
 * Developed by V8EN organization.
 * 
 * Contact: 582883825@qq.com
 * Website: https://v8en.com
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/app/app_theme.dart';
import 'package:password_manager/data/models/password_entry.dart';
import 'package:password_manager/presentation/providers/password_provider.dart';
import 'package:password_manager/presentation/screens/password_generator.dart';
import 'package:password_manager/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({Key? key}) : super(key: key);

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  // 当前选中的类型
  PasswordEntryType _selectedType = PasswordEntryType.login;

  // 基本信息控制器
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  // 动态字段控制器
  final Map<String, TextEditingController> _fieldControllers = {};

  // 标签
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFieldControllers();
  }

  void _initializeFieldControllers() {
    // 清理旧的控制器
    for (var controller in _fieldControllers.values) {
      controller.dispose();
    }
    _fieldControllers.clear();

    // 为当前类型创建控制器
    final fields = PasswordEntryTypeConfig.getFields(_selectedType);
    for (var field in fields) {
      _fieldControllers[field['key']] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    for (var controller in _fieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // 复制密码到剪贴板
  void _copyToClipboard(String text) {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.contentCopied)),
      );
    }
  }

  // 添加标签
  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  // 删除标签
  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  // 获取本地化的类型名称
  String _getLocalizedTypeName(PasswordEntryType type, AppLocalizations l10n) {
    switch (type) {
      case PasswordEntryType.login:
        return l10n.loginInfo;
      case PasswordEntryType.creditCard:
        return l10n.creditCard;
      case PasswordEntryType.identity:
        return l10n.identity;
      case PasswordEntryType.server:
        return l10n.server;
      case PasswordEntryType.database:
        return l10n.database;
      case PasswordEntryType.device:
        return l10n.secureDevice;
      case PasswordEntryType.wifi:
        return l10n.wifiPassword;
      case PasswordEntryType.secureNote:
        return l10n.secureNote;
      case PasswordEntryType.license:
        return l10n.softwareLicense;
      default:
        return PasswordEntryTypeConfig.getName(type);
    }
  }

  // 改变类型
  void _changeType(PasswordEntryType newType) {
    setState(() {
      _selectedType = newType;
      _initializeFieldControllers();
    });
  }

  // 保存新密码
  void _saveNewPassword() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<PasswordProvider>(context, listen: false);

      // 收集所有字段数据
      final fields = <String, dynamic>{};
      for (var entry in _fieldControllers.entries) {
        final value = entry.value.text.trim();
        if (value.isNotEmpty) {
          fields[entry.key] = value;
        }
      }

      final newPassword = PasswordEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        type: _selectedType,
        fields: fields,
        tags: List.from(_tags),
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 保存到仓库并返回主页面
      provider.savePassword(newPassword).then((_) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.newPasswordAdded),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeConfig = PasswordEntryTypeConfig.getConfig(_selectedType);
    final fields = PasswordEntryTypeConfig.getFields(_selectedType);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.addPasswordTitle(
            _getLocalizedTypeName(_selectedType, AppLocalizations.of(context)!),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _saveNewPassword,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.save_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.save,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 类型选择
              _buildTypeSelector(),
              const SizedBox(height: 24),

              // 标题（必填）
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '${AppLocalizations.of(context)!.title} *',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                  hintText: '例如：GitHub、网易邮箱、公司服务器',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.titleRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 动态字段
              Text(
                AppLocalizations.of(context)!.basicInfo,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              ...fields.map((field) => _buildDynamicField(field)).toList(),

              const SizedBox(height: 24),

              // 标签管理
              _buildTagsSection(),

              const SizedBox(height: 24),

              // 备注
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.notes,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                  alignLabelWithHint: true,
                  hintText: AppLocalizations.of(context)!.notesPlaceholder,
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // 密码生成器（仅对包含密码字段的类型显示）
              if (_hasPasswordField()) _buildPasswordGenerator(),
            ],
          ),
        ),
      ),
    );
  }

  // 构建类型选择器
  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.selectType,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        // 使用单行水平滚动布局，充分利用水平空间
        Container(
          height: 100, // 减小高度，因为只需要一行
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4),
            itemCount: PasswordEntryType.values.length,
            itemBuilder: (context, index) {
              final type = PasswordEntryType.values[index];
              final config = PasswordEntryTypeConfig.getConfig(type);
              final isSelected = type == _selectedType;

              return Container(
                width: 90, // 固定宽度，确保有足够空间显示文字
                margin: EdgeInsets.only(right: 12), // 图标间距
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _changeType(type),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(config['color']).withOpacity(0.12)
                            : AppTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? Color(config['color'])
                              : AppTheme.divider,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Color(
                                    config['color'],
                                  ).withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                  spreadRadius: 0.5,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: AppTheme.divider.withOpacity(0.08),
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIconData(config['icon']),
                            color: isSelected
                                ? Color(config['color'])
                                : AppTheme.textSecondary,
                            size: 28, // 恢复较大的图标尺寸
                          ),
                          SizedBox(height: 8),
                          Text(
                            _getLocalizedTypeName(
                              type,
                              AppLocalizations.of(context)!,
                            ),
                            style: TextStyle(
                              color: isSelected
                                  ? Color(config['color'])
                                  : AppTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              height: 1.0, // 紧凑行高
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1, // 强制单行显示
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 构建动态字段
  Widget _buildDynamicField(Map<String, dynamic> fieldConfig) {
    final key = fieldConfig['key'];
    final label = fieldConfig['label'];
    final type = fieldConfig['type'];
    final required = fieldConfig['required'] ?? false;
    final controller = _fieldControllers[key]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _buildFieldByType(controller, key, label, type, required),
    );
  }

  // 根据类型构建字段
  Widget _buildFieldByType(
    TextEditingController controller,
    String key,
    String label,
    String type,
    bool required,
  ) {
    final labelText = required ? '$label *' : label;

    switch (type) {
      case 'password':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.lock),
            helperText: '密码长度至少4位',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() {
                    _showPassword = !_showPassword;
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(controller.text),
                ),
              ],
            ),
          ),
          obscureText: !_showPassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => _validatePassword(value, label, required),
        );
      case 'email':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.email),
            helperText: '例如：user@example.com',
          ),
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => _validateEmail(value, label, required),
        );
      case 'url':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.link),
            helperText: '例如：https://example.com',
          ),
          keyboardType: TextInputType.url,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => _validateUrl(value, label, required),
        );
      case 'phone':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.phone),
            helperText: '例如：138-0013-8000 或 13800138000',
          ),
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => _validatePhone(value, label, required),
        );
      case 'number':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.numbers),
            helperText: _getNumberFieldHelp(key),
          ),
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => _validateNumber(value, label, required, key),
        );
      case 'textarea':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.text_fields),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => _validateTextArea(value, label, required),
        );
      case 'date':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.calendar_today),
            helperText: '格式：YYYY-MM-DD',
            suffixIcon: IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  controller.text = date.toIso8601String().split('T')[0];
                }
              },
            ),
          ),
          readOnly: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => _validateDate(value, label, required),
        );
      default: // text
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: _getFieldIcon(key),
            helperText: _getTextFieldHelp(key),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => _validateText(value, label, required, key),
        );
    }
  }

  // 构建标签区域
  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.tags,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.addTag,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                  hintText: '输入标签名称',
                ),
                onFieldSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: _addTag,
              ),
            ),
          ],
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags
                .map(
                  (tag) => Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => _removeTag(tag),
                    backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                    deleteIconColor: AppTheme.primaryBlue,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  // 构建密码生成器
  Widget _buildPasswordGenerator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.passwordGeneratorTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PasswordGenerator(
              onPasswordGenerated: (password) {
                // 设置到密码字段
                if (_fieldControllers.containsKey('password')) {
                  _fieldControllers['password']!.text = password;
                }
                if (_fieldControllers.containsKey('licenseKey')) {
                  _fieldControllers['licenseKey']!.text = password;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // 获取字段图标
  Icon _getFieldIcon(String key) {
    switch (key) {
      case 'username':
        return const Icon(Icons.person);
      case 'email':
        return const Icon(Icons.email);
      case 'url':
        return const Icon(Icons.link);
      case 'phone':
        return const Icon(Icons.phone);
      case 'cardNumber':
        return const Icon(Icons.credit_card);
      case 'serverAddress':
        return const Icon(Icons.dns);
      case 'databaseName':
        return const Icon(Icons.storage);
      case 'deviceName':
        return const Icon(Icons.devices);
      case 'ssid':
        return const Icon(Icons.wifi);
      case 'productName':
        return const Icon(Icons.apps);
      default:
        return const Icon(Icons.text_fields);
    }
  }

  // 获取图标数据
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'account_circle':
        return Icons.account_circle;
      case 'credit_card':
        return Icons.credit_card;
      case 'person':
        return Icons.person;
      case 'dns':
        return Icons.dns;
      case 'storage':
        return Icons.storage;
      case 'security':
        return Icons.security;
      case 'wifi':
        return Icons.wifi;
      case 'note':
        return Icons.note;
      case 'key':
        return Icons.key;
      default:
        return Icons.help;
    }
  }

  // 判断是否有密码字段
  bool _hasPasswordField() {
    final fields = PasswordEntryTypeConfig.getFields(_selectedType);
    return fields.any(
      (field) => field['key'] == 'password' || field['key'] == 'licenseKey',
    );
  }

  // === 表单验证方法 ===

  // 密码验证
  String? _validatePassword(String? value, String label, bool required) {
    if (required && (value == null || value.isEmpty)) {
      return '请输入$label';
    }
    if (value != null && value.isNotEmpty && value.length < 4) {
      return '$label长度不能少于4位';
    }
    return null;
  }

  // 邮箱验证
  String? _validateEmail(String? value, String label, bool required) {
    // 如果是必填字段且为空，返回错误
    if (required && (value == null || value.isEmpty)) {
      return '请输入$label';
    }
    // 如果是非必填字段且为空，不显示错误
    if (!required && (value == null || value.isEmpty)) {
      return null;
    }
    // 只有在有内容时才验证格式
    if (value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(value)) {
        return '请输入有效的邮箱地址';
      }
    }
    return null;
  }

  // URL验证
  String? _validateUrl(String? value, String label, bool required) {
    // 如果是必填字段且为空，返回错误
    if (required && (value == null || value.isEmpty)) {
      return '请输入$label';
    }
    // 如果是非必填字段且为空，不显示错误
    if (!required && (value == null || value.isEmpty)) {
      return null;
    }
    // 只有在有内容时才验证格式
    if (value != null && value.isNotEmpty) {
      final urlRegex = RegExp(
        r'^https?:\/\/[\w\.-]+(:[0-9]+)?(\/.*)?$',
        caseSensitive: false,
      );
      if (!urlRegex.hasMatch(value)) {
        return '请输入有效的URL地址（以http://或https://开头）';
      }
    }
    return null;
  }

  // 电话号码验证
  String? _validatePhone(String? value, String label, bool required) {
    // 如果是必填字段且为空，返回错误
    if (required && (value == null || value.isEmpty)) {
      return '请输入$label';
    }
    // 如果是非必填字段且为空，不显示错误
    if (!required && (value == null || value.isEmpty)) {
      return null;
    }
    // 只有在有内容时才验证格式
    if (value != null && value.isNotEmpty) {
      // 去除所有非数字字符
      final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (numbers.length < 7 || numbers.length > 15) {
        return '请输入有效的电话号码（7-15位数字）';
      }
      // 检查中国手机号格式
      if (numbers.length == 11 && !RegExp(r'^1[3-9]\d{9}$').hasMatch(numbers)) {
        return '请输入有效的中国手机号码';
      }
    }
    return null;
  }

  // 数字验证
  String? _validateNumber(
    String? value,
    String label,
    bool required,
    String key,
  ) {
    // 如果是必填字段且为空，返回错误
    if (required && (value == null || value.isEmpty)) {
      return '请输入$label';
    }
    // 如果是非必填字段且为空，不显示错误
    if (!required && (value == null || value.isEmpty)) {
      return null;
    }
    // 只有在有内容时才验证格式
    if (value != null && value.isNotEmpty) {
      final number = int.tryParse(value);
      if (number == null) {
        return '请输入有效的数字';
      }

      // 根据字段类型进行特定验证
      switch (key) {
        case 'port':
          if (number < 1 || number > 65535) {
            return '端口号必须在1-65535之间';
          }
          break;
        case 'cvv':
        case 'securityCode':
          if (value.length < 3 || value.length > 4) {
            return '安全码必须是3-4位数字';
          }
          break;
        case 'pin':
          if (value.length < 4 || value.length > 8) {
            return 'PIN码通常为4-8位数字';
          }
          break;
        case 'zipCode':
        case 'postalCode':
          if (value.length < 5 || value.length > 10) {
            return '邮编通常为5-10位数字';
          }
          break;
      }
    }
    return null;
  }

  // 文本区域验证
  String? _validateTextArea(String? value, String label, bool required) {
    if (required && (value == null || value.isEmpty)) {
      return '请输入$label';
    }
    return null;
  }

  // 日期验证
  String? _validateDate(String? value, String label, bool required) {
    if (required && (value == null || value.isEmpty)) {
      return '请选择$label';
    }
    if (value != null && value.isNotEmpty) {
      try {
        DateTime.parse(value);
      } catch (e) {
        return '请输入有效的日期格式（YYYY-MM-DD）';
      }
    }
    return null;
  }

  // 文本验证
  String? _validateText(
    String? value,
    String label,
    bool required,
    String key,
  ) {
    // 如果是必填字段且为空，返回错误
    if (required && (value == null || value.isEmpty)) {
      return '请输入$label';
    }
    // 如果是非必填字段且为空，不显示错误
    if (!required && (value == null || value.isEmpty)) {
      return null;
    }
    // 只有在有内容时才验证格式
    if (value != null && value.isNotEmpty) {
      // 根据字段类型进行特定验证
      switch (key) {
        case 'cardNumber':
          // 银行卡号验证（Luhn算法简化版）
          final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
          if (numbers.length < 13 || numbers.length > 19) {
            return '银行卡号通常为13-19位数字';
          }
          break;
        case 'idNumber':
        case 'identityCard':
          // 身份证号验证
          final cleanValue = value.replaceAll(RegExp(r'[^0-9Xx]'), '');
          if (cleanValue.length != 15 && cleanValue.length != 18) {
            return '身份证号应为15位或18位';
          }
          break;
        case 'licenseKey':
        case 'serialNumber':
          if (value.length < 8) {
            return '$label长度不能少于8位';
          }
          break;
        case 'username':
          if (value.length < 2) {
            return '用户名长度不能少于2位';
          }
          if (value.length > 50) {
            return '用户名长度不能超过50位';
          }
          break;
        case 'ssid':
          if (value.length > 32) {
            return 'WiFi名称长度不能超过32位';
          }
          break;
      }
    }
    return null;
  }

  // === 帮助文本方法 ===

  // 获取数字字段帮助文本
  String _getNumberFieldHelp(String key) {
    switch (key) {
      case 'port':
        return '端口号：1-65535';
      case 'cvv':
      case 'securityCode':
        return '信用卡安全码：3-4位数字';
      case 'pin':
        return 'PIN码：通常4-8位数字';
      case 'zipCode':
      case 'postalCode':
        return '邮政编码：如100000';
      case 'expiryMonth':
        return '过期月份：1-12';
      case 'expiryYear':
        return '过期年份：如2025';
      default:
        return '请输入数字';
    }
  }

  // 获取文本字段帮助文本
  String _getTextFieldHelp(String key) {
    switch (key) {
      case 'cardNumber':
        return '银行卡号：支持空格分隔';
      case 'idNumber':
      case 'identityCard':
        return '身份证号：15位或18位';
      case 'licenseKey':
      case 'serialNumber':
        return '许可证/序列号：至少8位';
      case 'username':
        return '用户名：2-50个字符';
      case 'ssid':
        return 'WiFi网络名称';
      case 'serverAddress':
        return '服务器地址或IP';
      case 'databaseName':
        return '数据库名称';
      case 'deviceName':
        return '设备名称或型号';
      case 'productName':
        return '软件/产品名称';
      case 'companyName':
        return '公司或组织名称';
      case 'holderName':
        return '持卡人姓名';
      default:
        return '';
    }
  }
}
