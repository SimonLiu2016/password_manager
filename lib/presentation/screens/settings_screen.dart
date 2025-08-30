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
import 'package:password_manager/main.dart';
import 'package:password_manager/utils/helpers/language_manager.dart';
import 'package:password_manager/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 安全设置
            _buildSectionHeader(l10n.securitySettings),
            _buildSecuritySettings(),

            SizedBox(height: 24),

            // 界面设置
            _buildSectionHeader(l10n.interfaceSettings),
            _buildInterfaceSettings(),

            SizedBox(height: 24),

            // 通知设置
            _buildSectionHeader(l10n.notificationSettings),
            _buildNotificationSettings(),

            SizedBox(height: 24),

            // 数据管理
            _buildSectionHeader(l10n.dataManagement),
            _buildDataManagement(),

            SizedBox(height: 24),

            // 关于
            _buildSectionHeader(l10n.about),
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
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }

  // 构建安全设置
  Widget _buildSecuritySettings() {
    final l10n = AppLocalizations.of(context)!;

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
            title: l10n.autoLockTime,
            subtitle: l10n.autoLockSubtitle(_autoLockTime),
            trailing: DropdownButton<int>(
              value: _autoLockTime,
              items: [1, 3, 5, 10, 15, 30]
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(l10n.minutesShort(value)),
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

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // 生物识别认证
          _buildSettingsTile(
            icon: Icons.fingerprint_rounded,
            title: l10n.biometricAuth,
            subtitle: l10n.biometricAuthSubtitle,
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
                      content: Text(l10n.biometricNotSupported),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                  return;
                }

                setState(() {
                  _biometricAuth = value;
                });
                _saveSettings();
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // 构建界面设置
  Widget _buildInterfaceSettings() {
    final l10n = AppLocalizations.of(context)!;

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
            title: l10n.theme,
            subtitle: _getThemeName(_selectedTheme),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              items: [
                DropdownMenuItem(value: 'light', child: Text(l10n.lightTheme)),
                DropdownMenuItem(value: 'dark', child: Text(l10n.darkTheme)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTheme = value;
                  });
                  _saveSettings();

                  // 通知主应用重新加载设置以应用主题
                  MyAppWrapper.reloadSettings(context);
                }
              },
            ),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // 语言设置
          _buildSettingsTile(
            icon: Icons.language_rounded,
            title: l10n.language,
            subtitle: _getLanguageName(_selectedLanguage),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: [
                DropdownMenuItem(value: 'zh', child: Text(l10n.chinese)),
                DropdownMenuItem(value: 'en', child: Text(l10n.english)),
              ],
              onChanged: (value) async {
                if (value != null && value != _selectedLanguage) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  await _saveSettings();

                  // 更新语言管理器
                  if (mounted) {
                    final languageManager = Provider.of<LanguageManager>(
                      context,
                      listen: false,
                    );
                    await languageManager.changeLanguage(value);
                  }
                }
              },
            ),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // 视图模式
          _buildSettingsTile(
            icon: Icons.view_list_rounded,
            title: l10n.passwordListView,
            subtitle: _getViewModeName(_viewMode),
            trailing: DropdownButton<String>(
              value: _viewMode,
              items: [
                DropdownMenuItem(value: 'list', child: Text(l10n.listView)),
                DropdownMenuItem(value: 'grid', child: Text(l10n.gridView)),
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
    final l10n = AppLocalizations.of(context)!;

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
            title: l10n.passwordExpiryReminder,
            subtitle: l10n.passwordExpirySubtitle,
            trailing: Switch(
              value: _passwordExpiryNotification,
              onChanged: (value) {
                setState(() {
                  _passwordExpiryNotification = value;
                });
                _saveSettings();
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // 安全提醒
          _buildSettingsTile(
            icon: Icons.security_rounded,
            title: l10n.securityAlerts,
            subtitle: l10n.securityAlertsSubtitle,
            trailing: Switch(
              value: _securityAlerts,
              onChanged: (value) {
                setState(() {
                  _securityAlerts = value;
                });
                _saveSettings();
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // 构建数据管理
  Widget _buildDataManagement() {
    final l10n = AppLocalizations.of(context)!;

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
            title: l10n.dataBackup,
            subtitle: l10n.dataBackupSubtitle,
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.backupFeatureComingSoon),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // 数据恢复
          _buildSettingsTile(
            icon: Icons.restore_rounded,
            title: l10n.dataRestore,
            subtitle: l10n.dataRestoreSubtitle,
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.restoreFeatureComingSoon),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // 数据导出
          _buildSettingsTile(
            icon: Icons.download_rounded,
            title: l10n.dataExport,
            subtitle: l10n.dataExportSubtitle,
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.exportFeatureComingSoon),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // 数据导入
          _buildSettingsTile(
            icon: Icons.upload_rounded,
            title: l10n.dataImport,
            subtitle: l10n.dataImportSubtitle,
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.importFeatureComingSoon),
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
    final l10n = AppLocalizations.of(context)!;

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
            title: l10n.versionInfo,
            subtitle: l10n.versionSubtitle,
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
                      l10n.aboutSecureVault,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(l10n.version, 'v1.0.0'),
                        _buildInfoRow(l10n.developer, 'V8EN'),
                        _buildInfoRow(l10n.author, 'Simon'),
                        _buildInfoRow(l10n.contact, '582883825@qq.com'),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.copyrightInfo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Text(
                                l10n.allRightsReserved,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
                        child: Text(l10n.ok),
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    final l10n = AppLocalizations.of(context)!;
    switch (theme) {
      case 'dark':
        return l10n.darkTheme;
      default:
        return l10n.lightTheme;
    }
  }

  // 获取语言名称
  String _getLanguageName(String language) {
    final l10n = AppLocalizations.of(context)!;
    switch (language) {
      case 'en':
        return l10n.english;
      default:
        return l10n.chinese;
    }
  }

  // 获取视图模式名称
  String _getViewModeName(String mode) {
    final l10n = AppLocalizations.of(context)!;
    switch (mode) {
      case 'grid':
        return l10n.gridView;
      default:
        return l10n.listView;
    }
  }
}
