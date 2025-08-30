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
import 'package:password_manager/app/app_theme.dart';
import 'package:password_manager/data/models/password_entry.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/presentation/providers/password_provider.dart';
import 'package:password_manager/presentation/screens/password_generator.dart';
import 'package:provider/provider.dart';
import 'package:password_manager/l10n/app_localizations.dart';

class PasswordDetails extends StatefulWidget {
  final PasswordEntry? selectedPassword;

  const PasswordDetails({Key? key, this.selectedPassword}) : super(key: key);

  @override
  State<PasswordDetails> createState() => _PasswordDetailsState();
}

class _PasswordDetailsState extends State<PasswordDetails> {
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();

  // 基本信息控制器
  late TextEditingController _titleController;
  late TextEditingController _notesController;

  // 动态字段控制器
  final Map<String, TextEditingController> _fieldControllers = {};

  // 标签管理
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _titleController = TextEditingController(
      text: widget.selectedPassword?.title ?? '',
    );
    _notesController = TextEditingController(
      text: widget.selectedPassword?.notes ?? '',
    );

    // 初始化标签（使用setState确保界面更新）
    setState(() {
      _tags.clear();
      if (widget.selectedPassword?.tags != null) {
        _tags.addAll(widget.selectedPassword!.tags);
      }
    });

    // 初始化动态字段控制器
    _initializeFieldControllers();
  }

  void _initializeFieldControllers() {
    // 清理旧的控制器
    for (var controller in _fieldControllers.values) {
      controller.dispose();
    }
    _fieldControllers.clear();

    if (widget.selectedPassword != null) {
      // 根据密码类型创建字段控制器
      final fields = PasswordEntryTypeConfig.getFields(
        widget.selectedPassword!.type,
      );
      for (var field in fields) {
        final key = field['key'];
        final value = widget.selectedPassword!.fields[key] ?? '';
        _fieldControllers[key] = TextEditingController(text: value.toString());
      }
    }
  }

  @override
  void didUpdateWidget(covariant PasswordDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('——— didUpdateWidget 被调用 ———');
    print('旧密码ID: ${oldWidget.selectedPassword?.id}');
    print('新密码ID: ${widget.selectedPassword?.id}');
    print('当前标签列表: $_tags');

    // 当selectedPassword变化时，重新初始化控制器
    if (oldWidget.selectedPassword?.id != widget.selectedPassword?.id) {
      print('密码ID发生变化，重新初始化控制器');
      _initControllers();
    } else if (widget.selectedPassword != null &&
        oldWidget.selectedPassword != null) {
      // 检查同一个密码对象的内容是否发生变化（特别是标签）
      final oldTags = oldWidget.selectedPassword!.tags;
      final newTags = widget.selectedPassword!.tags;

      print('旧标签: $oldTags');
      print('新标签: $newTags');

      // 如果标签发生变化，重新初始化标签列表
      if (oldTags.length != newTags.length ||
          !oldTags.every((tag) => newTags.contains(tag))) {
        print('检测到标签变化，更新标签列表');
        setState(() {
          _tags.clear();
          _tags.addAll(newTags);
          print('标签列表已更新为: $_tags');
        });
      } else {
        print('标签未发生变化');
      }

      // 检查其他字段是否变化，如果变化则更新控制器
      final oldFields = oldWidget.selectedPassword!.fields;
      final newFields = widget.selectedPassword!.fields;
      bool fieldsChanged = false;

      if (oldFields.length != newFields.length) {
        fieldsChanged = true;
      } else {
        for (var key in newFields.keys) {
          if (oldFields[key] != newFields[key]) {
            fieldsChanged = true;
            break;
          }
        }
      }

      if (fieldsChanged ||
          oldWidget.selectedPassword!.title != widget.selectedPassword!.title) {
        print('检测到字段或标题变化，更新控制器');
        // 更新文本控制器
        _titleController.text = widget.selectedPassword!.title;
        _notesController.text = widget.selectedPassword!.notes ?? '';

        // 更新动态字段控制器
        for (var entry in _fieldControllers.entries) {
          final key = entry.key;
          final value = widget.selectedPassword!.fields[key] ?? '';
          entry.value.text = value.toString();
        }
      }
    }
    print('——— didUpdateWidget 结束 ———\n');
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

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied(label))),
    );
  }

  void _savePassword() {
    print('——— 开始保存密码 ———');
    print('当前标签列表: $_tags');
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<PasswordProvider>(context, listen: false);

      // 收集所有字段数据
      final updatedFields = <String, dynamic>{};
      for (var entry in _fieldControllers.entries) {
        final value = entry.value.text.trim();
        if (value.isNotEmpty) {
          updatedFields[entry.key] = value;
        }
      }

      final tagsToSave = List<String>.from(_tags);
      print('即将保存的标签: $tagsToSave');

      final updatedPassword = widget.selectedPassword?.copyWith(
        title: _titleController.text.trim(),
        fields: updatedFields,
        tags: tagsToSave,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        updatedAt: DateTime.now(),
      );

      print('更新后的密码对象标签: ${updatedPassword?.tags}');

      if (updatedPassword != null) {
        provider.savePassword(updatedPassword).then((_) {
          print('密码保存完成');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.passwordSaved),
            ),
          );
        });
      }
    }
    print('——— 保存密码结束 ———\n');
  }

  // 切换收藏状态
  void _toggleFavorite() {
    final provider = Provider.of<PasswordProvider>(context, listen: false);
    if (widget.selectedPassword != null) {
      provider.toggleFavorite(widget.selectedPassword!.id).then((_) {
        final action = widget.selectedPassword!.isFavorite
            ? AppLocalizations.of(context)!.removedFromFavorites
            : AppLocalizations.of(context)!.addedToFavorites;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(action),
            backgroundColor: widget.selectedPassword!.isFavorite
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
          ),
        );
      });
    }
  }

  void _deletePassword() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<PasswordProvider>(context, listen: false);

      provider.deletePassword(widget.selectedPassword!.id).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.passwordDeleted),
          ),
        );
        // 清空控制器文本
        _initControllers();
      });
    }
  }

  // 显示删除确认对话框
  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.confirmDelete,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!.deleteConfirmMessage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deletePassword();
                },
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
                  onPressed: () => _copyToClipboard(controller.text, label),
                ),
              ],
            ),
          ),
          obscureText: !_showPassword,
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入$label';
                  }
                  return null;
                }
              : null,
        );
      case 'email':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.email),
            suffixIcon: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard(controller.text, label),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入$label';
                  }
                  return null;
                }
              : null,
        );
      case 'url':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.link),
            suffixIcon: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard(controller.text, label),
            ),
          ),
          keyboardType: TextInputType.url,
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入$label';
                  }
                  return null;
                }
              : null,
        );
      case 'phone':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.phone),
            suffixIcon: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard(controller.text, label),
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入$label';
                  }
                  return null;
                }
              : null,
        );
      case 'number':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.numbers),
            suffixIcon: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard(controller.text, label),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入$label';
                  }
                  return null;
                }
              : null,
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
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入$label';
                  }
                  return null;
                }
              : null,
        );
      case 'date':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.calendar_today),
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
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '请选择$label';
                  }
                  return null;
                }
              : null,
        );
      default: // text
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: _getFieldIcon(key),
            suffixIcon: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard(controller.text, label),
            ),
          ),
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入$label';
                  }
                  return null;
                }
              : null,
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
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.addTag,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                onFieldSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _addTag,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
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
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    deleteIconColor: Theme.of(context).colorScheme.primary,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  // 添加标签
  void _addTag() {
    final tag = _tagController.text.trim();
    print('尝试添加标签: "$tag"');
    print('当前标签列表: $_tags');
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
        print('标签添加成功，新的标签列表: $_tags');
      });
    } else {
      print('标签添加失败: 标签为空或已存在');
    }
  }

  // 删除标签
  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  // 获取字段图标
  Widget _getFieldIcon(String key) {
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

  // 获取类型图标
  IconData _getTypeIcon(String iconName) {
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
        return PasswordEntryTypeConfig.getName(type); // 降级到中文名称
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedPassword == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noPasswordSelected,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 16,
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: AppLocalizations.of(context)!.details),
                Tab(text: AppLocalizations.of(context)!.passwordGenerator),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  // 详情表单
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // 类型显示
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(
                                PasswordEntryTypeConfig.getColor(
                                  widget.selectedPassword!.type,
                                ),
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(
                                  PasswordEntryTypeConfig.getColor(
                                    widget.selectedPassword!.type,
                                  ),
                                ),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getTypeIcon(
                                    PasswordEntryTypeConfig.getIcon(
                                      widget.selectedPassword!.type,
                                    ),
                                  ),
                                  color: Color(
                                    PasswordEntryTypeConfig.getColor(
                                      widget.selectedPassword!.type,
                                    ),
                                  ),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _getLocalizedTypeName(
                                    widget.selectedPassword!.type,
                                    AppLocalizations.of(context)!,
                                  ),
                                  style: TextStyle(
                                    color: Color(
                                      PasswordEntryTypeConfig.getColor(
                                        widget.selectedPassword!.type,
                                      ),
                                    ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 标题字段
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.title,
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.title),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(
                                  context,
                                )!.titleRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // 动态字段部分
                          Text(
                            AppLocalizations.of(context)!.basicInfo,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(height: 16),

                          // 根据类型生成动态字段
                          ...PasswordEntryTypeConfig.getFields(
                            widget.selectedPassword!.type,
                          ).map((field) => _buildDynamicField(field)).toList(),

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
                              hintText: AppLocalizations.of(
                                context,
                              )!.notesPlaceholder,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 32),

                          // 收藏按钮 - 现代化设计
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: widget.selectedPassword!.isFavorite
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).dividerColor,
                                width: 2,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: _toggleFavorite,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      widget.selectedPassword!.isFavorite
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: widget.selectedPassword!.isFavorite
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.secondary
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      widget.selectedPassword!.isFavorite
                                          ? AppLocalizations.of(
                                              context,
                                            )!.removeFromFavorites
                                          : AppLocalizations.of(
                                              context,
                                            )!.addToFavorites,
                                      style: TextStyle(
                                        color:
                                            widget.selectedPassword!.isFavorite
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.secondary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 保存按钮 - 现代化设计
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: AppTheme.primaryGradientDecoration,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: _savePassword,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.save_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.saveChanges,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 删除按钮 - 现代化设计
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.error,
                                width: 2,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _showDeleteConfirmDialog(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete_rounded,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.deletePassword,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 密码生成器（使用包装组件）
                  _PasswordGeneratorWrapper(
                    onPasswordGenerated: (password) {
                      // 设置到密码字段
                      if (_fieldControllers.containsKey('password')) {
                        _fieldControllers['password']!.text = password;
                      }
                      if (_fieldControllers.containsKey('licenseKey')) {
                        _fieldControllers['licenseKey']!.text = password;
                      }
                      if (_fieldControllers.containsKey('cvv')) {
                        _fieldControllers['cvv']!.text = password;
                      }
                      if (_fieldControllers.containsKey('pin')) {
                        _fieldControllers['pin']!.text = password;
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 密码生成器包装组件（保持状态）
class _PasswordGeneratorWrapper extends StatefulWidget {
  final Function(String) onPasswordGenerated;

  const _PasswordGeneratorWrapper({required this.onPasswordGenerated});

  @override
  State<_PasswordGeneratorWrapper> createState() =>
      _PasswordGeneratorWrapperState();
}

class _PasswordGeneratorWrapperState extends State<_PasswordGeneratorWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PasswordGenerator(onPasswordGenerated: widget.onPasswordGenerated);
  }
}
