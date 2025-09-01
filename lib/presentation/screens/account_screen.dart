/*
 * Password Manager - Account Screen
 * 
 * Copyright (c) 2024 V8EN (https://v8en.com)
 * Author: Simon <582883825@qq.com>
 * 
 * This file contains the account screen implementation for the Password Manager application.
 * Developed by V8EN organization.
 * 
 * Contact: 582883825@qq.com
 * Website: https://v8en.com
 */

import 'package:flutter/material.dart';
import 'package:password_manager/app/app_theme.dart';
import 'package:password_manager/presentation/providers/password_provider.dart';
import 'package:password_manager/presentation/providers/auth_provider.dart';
import 'package:password_manager/presentation/components/authentication/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _localAuth = LocalAuthentication();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isBiometricAvailable = false;
  bool _showChangePassword = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 检查生物识别可用性
  Future<void> _checkBiometricAvailability() async {
    try {
      final canAuthenticate = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      setState(() {
        _isBiometricAvailable = canAuthenticate || isDeviceSupported;
      });
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          '我的账户',
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
            // 账户信息卡片
            _buildAccountInfoCard(),

            SizedBox(height: 24),

            // 认证管理
            _buildSectionHeader('认证管理'),
            _buildAuthManagement(),

            SizedBox(height: 24),

            // 使用统计
            _buildSectionHeader('使用统计'),
            _buildUsageStatistics(),

            SizedBox(height: 24),

            // 安全建议
            _buildSectionHeader('安全建议'),
            _buildSecurityTips(),
          ],
        ),
      ),
    );
  }

  // 构建账户信息卡片
  Widget _buildAccountInfoCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Consumer<PasswordProvider>(
        builder: (context, passwordProvider, child) {
          final totalPasswords = passwordProvider.passwords.length;
          final favoritePasswords = passwordProvider.favoriteCount;

          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SecureVault 用户',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '账户安全等级: 高',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    _buildStatItem('总密码数', '$totalPasswords'),
                    SizedBox(width: 20),
                    _buildStatItem('收藏密码', '$favoritePasswords'),
                    SizedBox(width: 20),
                    _buildStatItem('账户时长', '30天'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 构建统计数据项
  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
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

  // 构建认证管理
  Widget _buildAuthManagement() {
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
          // 生物识别认证
          _buildSettingsTile(
            icon: Icons.fingerprint_rounded,
            title: '生物识别认证',
            subtitle: _isBiometricAvailable ? '已启用指纹/面部识别' : '设备不支持生物识别',
            trailing: _isBiometricAvailable
                ? Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.success,
                    size: 20,
                  )
                : Icon(Icons.error_rounded, color: AppTheme.error, size: 20),
          ),

          Divider(height: 1, color: AppTheme.divider),

          // 修改密码
          _buildSettingsTile(
            icon: Icons.lock_rounded,
            title: '修改密码',
            subtitle: '更改应用解锁密码',
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            onTap: () {
              setState(() {
                _showChangePassword = !_showChangePassword;
              });
            },
          ),

          // 修改密码表单（条件显示）
          if (_showChangePassword) _buildChangePasswordForm(),

          Divider(height: 1, color: AppTheme.divider),

          // 忘记密码
          _buildSettingsTile(
            icon: Icons.help_rounded,
            title: '忘记密码',
            subtitle: '重置应用解锁密码',
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            onTap: _showResetPasswordDialog,
          ),
        ],
      ),
    );
  }

  // 显示重置密码对话框
  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_rounded, color: AppTheme.error, size: 24),
              SizedBox(width: 12),
              Text(
                '忘记密码',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            '重置密码将清除所有已保存的密码数据，且无法恢复。请确保已备份重要数据。\n\n此操作不可撤销，是否继续？',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('取消'),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showResetPasswordForm();
                },
                child: Text(
                  '重置密码',
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

  // 显示重置密码表单
  void _showResetPasswordForm() {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isPasswordVisible = false;
    bool isConfirmPasswordVisible = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                '重置密码',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 新密码输入框
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: '新密码',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.lock_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // 确认新密码输入框
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: '确认新密码',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.lock_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('取消'),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final newPassword = newPasswordController.text;
                      final confirmPassword = confirmPasswordController.text;

                      // 验证输入
                      if (newPassword.isEmpty || confirmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('请填写所有字段'),
                            backgroundColor: AppTheme.error,
                          ),
                        );
                        return;
                      }

                      if (newPassword != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('两次输入的密码不一致'),
                            backgroundColor: AppTheme.error,
                          ),
                        );
                        return;
                      }

                      if (newPassword.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('密码长度至少6位'),
                            backgroundColor: AppTheme.error,
                          ),
                        );
                        return;
                      }

                      try {
                        // 获取密码提供者
                        final passwordProvider = Provider.of<PasswordProvider>(
                          context,
                          listen: false,
                        );

                        // 清除所有密码数据
                        await passwordProvider.clearAllPasswords();

                        // 重置主密码
                        final authService = AuthService();
                        await authService.resetMasterPassword(newPassword);

                        // 显示成功消息
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('密码重置成功，请重新登录'),
                            backgroundColor: AppTheme.success,
                          ),
                        );

                        // 锁定应用
                        Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).lock();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('密码重置失败: $e'),
                            backgroundColor: AppTheme.error,
                          ),
                        );
                      }
                    },
                    child: Text(
                      '重置',
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
      },
    );
  }

  // 构建修改密码表单
  Widget _buildChangePasswordForm() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 当前密码
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: '当前密码',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.lock_outline_rounded, size: 20),
            ),
          ),
          SizedBox(height: 12),

          // 新密码
          TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: '新密码',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.lock_rounded, size: 20),
            ),
          ),
          SizedBox(height: 12),

          // 确认新密码
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: '确认新密码',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.lock_rounded, size: 20),
            ),
          ),
          SizedBox(height: 16),

          // 提交按钮
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: _handleChangePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '修改密码',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 处理修改密码
  Future<void> _handleChangePassword() async {
    final currentPassword = _passwordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // 验证输入
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请填写所有字段'), backgroundColor: AppTheme.error),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('新密码与确认密码不一致'), backgroundColor: AppTheme.error),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('新密码长度至少6位'), backgroundColor: AppTheme.error),
      );
      return;
    }

    // 显示加载状态
    setState(() {
      // 可以添加加载指示器
    });

    try {
      final authService = AuthService();
      final success = await authService.changeMasterPassword(
        currentPassword,
        newPassword,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('密码修改成功'), backgroundColor: AppTheme.success),
        );

        // 清空输入框
        _passwordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        // 隐藏表单
        setState(() {
          _showChangePassword = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('当前密码错误'), backgroundColor: AppTheme.error),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('密码修改失败: $e'), backgroundColor: AppTheme.error),
      );
    }
  }

  // 构建使用统计
  Widget _buildUsageStatistics() {
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
          // 密码类型统计
          _buildSettingsTile(
            icon: Icons.category_rounded,
            title: '密码类型统计',
            subtitle: '查看各类密码分布',
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            onTap: _showPasswordTypeStats,
          ),

          Divider(height: 1, color: AppTheme.divider),

          // 登录历史
          _buildSettingsTile(
            icon: Icons.history_rounded,
            title: '登录历史',
            subtitle: '最近的登录记录',
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            onTap: _showLoginHistory,
          ),
        ],
      ),
    );
  }

  // 显示密码类型统计
  void _showPasswordTypeStats() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许更大的高度
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1,
          ), // 往上移动，距离顶部10%
          height: 400, // 固定高度为300像素
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '密码类型统计',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: Consumer<PasswordProvider>(
                  builder: (context, passwordProvider, child) {
                    final passwords = passwordProvider.passwords;

                    // 统计各类密码数量
                    final typeCounts = <String, int>{};
                    for (final password in passwords) {
                      final typeName = password.type.toString().split('.').last;
                      typeCounts[typeName] = (typeCounts[typeName] ?? 0) + 1;
                    }

                    // 如果没有密码数据，显示提示信息
                    if (typeCounts.isEmpty) {
                      return Center(
                        child: Text(
                          '暂无密码数据',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: typeCounts.length,
                      itemBuilder: (context, index) {
                        final entry = typeCounts.entries.elementAt(index);
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: Text(
                                  _getTypeDisplayName(entry.key),
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: entry.value / passwords.length,
                                  backgroundColor: AppTheme.divider,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.primaryBlue,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                '${entry.value}',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 显示登录历史
  void _showLoginHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许更大的高度
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1,
          ), // 往上移动，距离顶部10%
          height: 300, // 固定高度为300像素
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '登录历史',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildHistoryItem('今天 14:30', 'Windows 11', 'Chrome'),
                    _buildHistoryItem('今天 09:15', 'macOS 14', 'Safari'),
                    _buildHistoryItem('昨天 20:45', 'Windows 11', 'Chrome'),
                    _buildHistoryItem(
                      '昨天 16:20',
                      'Android 14',
                      'SecureVault App',
                    ),
                    _buildHistoryItem('3天前 11:10', 'iOS 17', 'SecureVault App'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 构建历史记录项
  Widget _buildHistoryItem(String time, String device, String app) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.divider, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getDeviceIcon(device),
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$device · $app',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 获取设备图标
  IconData _getDeviceIcon(String device) {
    if (device.contains('Windows')) {
      return Icons.desktop_windows_rounded;
    } else if (device.contains('macOS')) {
      return Icons.computer_rounded;
    } else if (device.contains('Android')) {
      return Icons.phone_android_rounded;
    } else if (device.contains('iOS')) {
      return Icons.phone_iphone_rounded;
    } else {
      return Icons.devices_rounded;
    }
  }

  // 获取类型显示名称
  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'login':
        return '登录信息';
      case 'creditCard':
        return '信用卡';
      case 'identity':
        return '身份标识';
      case 'secureNote':
        return '安全笔记';
      case 'server':
        return '服务器';
      case 'database':
        return '数据库';
      case 'device':
        return '安全设备';
      case 'wifi':
        return 'WiFi密码';
      case 'license':
        return '软件许可证';
      default:
        return type;
    }
  }

  // 构建安全建议
  Widget _buildSecurityTips() {
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
          _buildTipItem(
            icon: Icons.shield_rounded,
            title: '使用强密码',
            description: '建议使用至少12位包含大小写字母、数字和特殊字符的密码',
            color: AppTheme.primaryBlue,
          ),
          Divider(height: 1, color: AppTheme.divider),
          _buildTipItem(
            icon: Icons.refresh_rounded,
            title: '定期更换密码',
            description: '重要账户建议每3个月更换一次密码',
            color: AppTheme.success,
          ),
          Divider(height: 1, color: AppTheme.divider),
          _buildTipItem(
            icon: Icons.people_rounded,
            title: '避免密码复用',
            description: '不要在多个网站使用相同的密码',
            color: AppTheme.warning,
          ),
        ],
      ),
    );
  }

  // 构建建议项
  Widget _buildTipItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                ),
              ],
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
}
