/*
 * Password Manager - Settings Screen
 * 
 * Copyright (c) 2024 V8EN (https://v8en.com)
 * Author: Simon <582883825@qq.com>
 * 
 * This file contains the settings screen implementation for the Password Manager application.
 * Developed by V8EN organization.
 * 
 * Contact: 582883825@qq.com
 * Website: https://v8en.com
 */

import 'package:flutter/material.dart';
import 'package:password_manager/app/app_theme.dart';
import 'package:password_manager/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 安全设置
  int _autoLockTime = 5; // 自动锁定时间（分钟）
  bool _biometricAuth = true; // 生物识别认证

  // 界面设置
  String _selectedTheme = 'light'; // 主题
  String _selectedLanguage = 'zh'; // 语言
  String _viewMode = 'list'; // 视图模式

  // 通知设置
  bool _passwordExpiryNotification = true; // 密码到期提醒
  bool _securityAlerts = true; // 安全提醒

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // 加载设置
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _autoLockTime = prefs.getInt('autoLockTime') ?? 5;
      _biometricAuth = prefs.getBool('biometricAuth') ?? true;
      _selectedTheme = prefs.getString('theme') ?? 'light';
      _selectedLanguage = prefs.getString('language') ?? 'zh';
      _viewMode = prefs.getString('viewMode') ?? 'list';
      _passwordExpiryNotification =
          prefs.getBool('passwordExpiryNotification') ?? true;
      _securityAlerts = prefs.getBool('securityAlerts') ?? true;
    });
  }

  // 保存设置
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('autoLockTime', _autoLockTime);
    await prefs.setBool('biometricAuth', _biometricAuth);
    await prefs.setString('theme', _selectedTheme);
    await prefs.setString('language', _selectedLanguage);
    await prefs.setString('viewMode', _viewMode);
    await prefs.setBool(
      'passwordExpiryNotification',
      _passwordExpiryNotification,
    );
    await prefs.setBool('securityAlerts', _securityAlerts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          '设置',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 安全设置
            _buildSectionHeader('安全设置'),
            _buildSecuritySettings(),

            SizedBox(height: 24),

            // 界面设置
            _buildSectionHeader('界面设置'),
            _buildInterfaceSettings(),

            SizedBox(height: 24),

            // 通知设置
            _buildSectionHeader('通知设置'),
            _buildNotificationSettings(),

            SizedBox(height: 24),

            // 数据管理
            _buildSectionHeader('数据管理'),
            _buildDataManagement(),

            SizedBox(height: 24),

            // 关于
            _buildSectionHeader('关于'),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  // 构建章节标题
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  // 构建安全设置
  Widget _buildSecuritySettings() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 自动锁定时间
          _buildSettingsTile(
            icon: Icons.lock_rounded,
            title: '自动锁定时间',
            subtitle: '$_autoLockTime 分钟无操作后自动锁定',
            trailing: DropdownButton<int>(
              value: _autoLockTime,
              items: [1, 3, 5, 10, 15, 30]
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text('$value 分钟'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _autoLockTime = value;
                  });
                  _saveSettings();
                }
              },
            ),
          ),

          Divider(height: 1, color: AppTheme.divider),

          // 生物识别认证
          _buildSettingsTile(
            icon: Icons.fingerprint_rounded,
            title: '生物识别认证',
            subtitle: '使用指纹或面部识别解锁应用',
            trailing: Switch(
              value: _biometricAuth,
              onChanged: (value) async {
                // 检查设备是否支持生物识别
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final isAvailable = await authProvider.isBiometricAvailable();

                if (!isAvailable && value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('设备不支持生物识别认证'),
                      backgroundColor: AppTheme.error,
                    ),
                  );
                  return;
                }

                setState(() {
                  _biometricAuth = value;
                });
                _saveSettings();
              },
              activeColor: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  // 构建界面设置
  Widget _buildInterfaceSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 主题设置
          _buildSettingsTile(
            icon: Icons.palette_rounded,
            title: '主题',
            subtitle: _getThemeName(_selectedTheme),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              items: [
                DropdownMenuItem(value: 'light', child: Text('浅色')),
                DropdownMenuItem(value: 'dark', child: Text('深色')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTheme = value;
                  });
                  _saveSettings();
                }
              },
            ),
          ),

          Divider(height: 1, color: AppTheme.divider),

          // 语言设置
          _buildSettingsTile(
            icon: Icons.language_rounded,
            title: '语言',
            subtitle: _getLanguageName(_selectedLanguage),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: [
                DropdownMenuItem(value: 'zh', child: Text('中文')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  _saveSettings();
                }
              },
            ),
          ),

          Divider(height: 1, color: AppTheme.divider),

          // 视图模式
          _buildSettingsTile(
            icon: Icons.view_list_rounded,
            title: '密码列表视图',
            subtitle: _getViewModeName(_viewMode),
            trailing: DropdownButton<String>(
              value: _viewMode,
              items: [
                DropdownMenuItem(value: 'list', child: Text('列表')),
                DropdownMenuItem(value: 'grid', child: Text('网格')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _viewMode = value;
                  });
                  _saveSettings();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // 构建通知设置
  Widget _buildNotificationSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 密码到期提醒
          _buildSettingsTile(
            icon: Icons.event_rounded,
            title: '密码到期提醒',
            subtitle: '定期提醒您更新重要密码',
            trailing: Switch(
              value: _passwordExpiryNotification,
              onChanged: (value) {
                setState(() {
                  _passwordExpiryNotification = value;
                });
                _saveSettings();
              },
              activeColor: AppTheme.primaryBlue,
            ),
          ),

          Divider(height: 1, color: AppTheme.divider),

          // 安全提醒
          _buildSettingsTile(
            icon: Icons.security_rounded,
            title: '安全提醒',
            subtitle: '接收安全相关的通知和建议',
            trailing: Switch(
              value: _securityAlerts,
              onChanged: (value) {
                setState(() {
                  _securityAlerts = value;
                });
                _saveSettings();
              },
              activeColor: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  // 构建数据管理
  Widget _buildDataManagement() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 数据备份
          _buildSettingsTile(
            icon: Icons.backup_rounded,
            title: '数据备份',
            subtitle: '创建本地备份文件',
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('备份功能将在后续版本中实现'),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              );
            },
          ),

          Divider(height: 1, color: AppTheme.divider),

          // 数据恢复
          _buildSettingsTile(
            icon: Icons.restore_rounded,
            title: '数据恢复',
            subtitle: '从备份文件恢复数据',
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('恢复功能将在后续版本中实现'),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              );
            },
          ),

          Divider(height: 1, color: AppTheme.divider),

          // 数据导出
          _buildSettingsTile(
            icon: Icons.download_rounded,
            title: '导出数据',
            subtitle: '导出为加密文件',
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('导出功能将在后续版本中实现'),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              );
            },
          ),

          Divider(height: 1, color: AppTheme.divider),

          // 数据导入
          _buildSettingsTile(
            icon: Icons.upload_rounded,
            title: '导入数据',
            subtitle: '从文件导入密码数据',
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('导入功能将在后续版本中实现'),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 构建关于部分
  Widget _buildAboutSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 版本信息
          _buildSettingsTile(
            icon: Icons.info_rounded,
            title: '版本信息',
            subtitle: 'SecureVault v1.0.0',
            onTap: () {
              // 显示详细版本信息
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      '关于 SecureVault',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('版本', 'v1.0.0'),
                        _buildInfoRow('开发者', 'V8EN'),
                        _buildInfoRow('作者', 'Simon'),
                        _buildInfoRow('联系方式', '582883825@qq.com'),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.primaryBlue.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Copyright © 2024 V8EN',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                              Text(
                                '保留所有权利',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('确定'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            child: Text(
              '$label:',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建设置项
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
          bottom: Radius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  // 获取主题名称
  String _getThemeName(String theme) {
    switch (theme) {
      case 'dark':
        return '深色';
      default:
        return '浅色';
    }
  }

  // 获取语言名称
  String _getLanguageName(String language) {
    switch (language) {
      case 'en':
        return 'English';
      default:
        return '中文';
    }
  }

  // 获取视图模式名称
  String _getViewModeName(String mode) {
    switch (mode) {
      case 'grid':
        return '网格';
      default:
        return '列表';
    }
  }
}
