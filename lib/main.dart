/*
 * Password Manager - A secure and feature-rich password management application
 * 
 * Copyright (c) 2024 V8EN (https://v8en.com)
 * Author: Simon <582883825@qq.com>
 * 
 * This software is developed by V8EN organization.
 * For more information, visit: https://v8en.com
 * Contact: 582883825@qq.com
 * 
 * All rights reserved.
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:password_manager/app/app_theme.dart';
import 'package:password_manager/presentation/components/password_window_listener.dart';
import 'package:password_manager/presentation/components/navigator_key_holder.dart';
import 'package:password_manager/presentation/providers/auth_provider.dart';
import 'package:password_manager/presentation/providers/password_provider.dart';
import 'package:password_manager/presentation/screens/lock_screen.dart';
import 'package:password_manager/presentation/screens/main_screen.dart';
import 'package:password_manager/utils/constants/system_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化窗口管理器
  await windowManager.ensureInitialized();
  // 设置拦截原始关闭
  await windowManager.setPreventClose(true);
  // 监听窗口关闭事件
  windowManager.addListener(PasswordWindowListener());

  // 初始化密码仓库
  final passwordProvider = PasswordProvider();
  await passwordProvider.initialize();

  // 配置窗口属性
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1000, 800),
    center: true,
    backgroundColor: Color.fromARGB(0, 250, 248, 248),
    skipTaskbar: false,
    title: 'SecureVault - V8EN',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // 检查认证状态
  //final isAuthenticated = await AuthService().authenticate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PasswordProvider>.value(value: passwordProvider),
        ChangeNotifierProvider<AuthProvider>.value(value: AuthProvider()),
      ],
      child: MyAppWrapper(),
    ),
  );
}

class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({Key? key}) : super(key: key);

  @override
  _MyAppWrapperState createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> with TrayListener {
  ValueNotifier<bool> shouldForegroundOnContextMenu = ValueNotifier(false);
  String _iconType = kIconTypeOriginal;
  Menu? _menu;
  Timer? _timer;
  var isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    trayManager.addListener(this);
    handleSetIcon(kIconTypeDefault);

    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 加载设置
      await _loadSettings();
      authProvider.authenticate();
      resetIdleTimer(context);
    });
  }

  Future<void> handleSetIcon(String iconType) async {
    _iconType = iconType;
    String iconPath = Platform.isWindows
        ? 'images/tray_icon_new.ico'
        : 'images/tray_icon_new.png';

    if (_iconType == 'original') {
      iconPath = Platform.isWindows
          ? 'images/tray_icon_unlocked.ico'
          : 'images/tray_icon_unlocked.png';
    }

    await trayManager.setIcon(iconPath);

    _menu = Menu(
      items: [
        MenuItem(label: '锁定', onClick: (item) => _onLock()),
        MenuItem(label: '偏好设置', onClick: (item) => _onSettings()),
        MenuItem(label: '打开 Secure Vault', onClick: (item) => _onOpen()),

        MenuItem.separator(),
        MenuItem(label: '关于 V8EN', onClick: (item) => _onAbout()),
        MenuItem(label: '完全退出', onClick: (item) => _onQuit()),
      ],
    );
    // 设置托盘菜单
    await trayManager.setContextMenu(_menu!);
  }

  void _onOpen() async {
    await windowManager.setSkipTaskbar(false);
    await windowManager.show();

    if (!isLoggedIn) {
      Provider.of<AuthProvider>(context, listen: false).authenticate();
    } else {
      await windowManager.focus();
    }
  }

  void _onLock() {
    try {
      // 首先导航回主界面，清除所有子页面
      final navigator = NavigatorKeyHolder.navigatorKey.currentState;
      if (navigator != null) {
        // 弹出所有页面直到根页面
        navigator.popUntil((route) => route.isFirst);
      }
    } catch (e) {
      // 如果导航失败，记录错误但不阻止锁定操作
      print('导航失败: $e');
    }

    // 然后锁定应用
    Provider.of<AuthProvider>(context, listen: false).lock();

    // 确保窗口显示并聚焦，让用户看到锁定界面
    windowManager.show();
    windowManager.focus();
  }

  void _onSettings() {
    // 打开设置页面
    print("on settings");
  }

  void _onAbout() {
    // 确保窗口显示并获得焦点
    windowManager.show();
    windowManager.focus();

    // 延迟一点时间确保窗口已经获得焦点
    Future.delayed(Duration(milliseconds: 100), () {
      final navigator = NavigatorKeyHolder.navigatorKey.currentState;
      if (navigator != null && navigator.mounted) {
        // 显示关于对话框
        showDialog(
          context: navigator.context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.info_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '关于 SecureVault',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔐 SecureVault Password Manager v1.0.0',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow('组织', 'V8EN'),
                  _buildInfoRow('开发者', 'Simon'),
                  _buildInfoRow('联系方式', '582883825@qq.com'),
                  SizedBox(height: 12),
                  _buildWebsiteRow('官方网站', 'https://v8en.com'),
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
                            fontWeight: FontWeight.w600,
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
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      '确定',
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
      } else {
        // 如果navigator不可用，打印调试信息
        print('Navigator不可用，无法显示关于对话框');
      }
    });
  }

  // 构建信息行的辅助方法
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
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

  // 构建网站链接行（可点击）
  Widget _buildWebsiteRow(String label, String url) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => _launchUrl(url),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.language_rounded,
                      size: 16,
                      color: AppTheme.primaryBlue,
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        url,
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 14,
                      color: AppTheme.primaryBlue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 打开URL的方法
  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('无法打开URL: $url');
        // 显示错误提示
        final navigator = NavigatorKeyHolder.navigatorKey.currentState;
        if (navigator != null && navigator.mounted) {
          ScaffoldMessenger.of(navigator.context).showSnackBar(
            SnackBar(
              content: Text('无法打开网站链接'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    } catch (e) {
      print('打开URL时发生错误: $e');
      // 显示错误提示
      final navigator = NavigatorKeyHolder.navigatorKey.currentState;
      if (navigator != null && navigator.mounted) {
        ScaffoldMessenger.of(navigator.context).showSnackBar(
          SnackBar(content: Text('打开网站链接失败'), backgroundColor: AppTheme.error),
        );
      }
    }
  }

  void _onQuit() async {
    await windowManager.close();
    exit(0);
  }

  void _startIconFlashing() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      handleSetIcon(
        _iconType == kIconTypeOriginal ? kIconTypeDefault : kIconTypeOriginal,
      );
    });
    // setState(() {});
  }

  void _stopIconFlashing() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    // setState(() {});
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  // 定义闲置时间，从设置中读取
  int idleTime = 5 * 60; // 默认5分钟

  // 从设置加载自动锁定时间和生物识别设置
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAutoLockTime = prefs.getInt('autoLockTime') ?? 5;
    idleTime = savedAutoLockTime * 60; // 转换为秒

    // 检查是否启用生物识别认证
    final biometricAuthEnabled = prefs.getBool('biometricAuth') ?? true;

    // 如果设置中禁用了生物识别，则不使用生物识别认证
    if (!biometricAuthEnabled) {
      // 这里可以添加相应的处理逻辑
    }
  }

  Timer? idleTimer;

  void resetIdleTimer(BuildContext context) async {
    // 每次重置时都重新加载设置
    await _loadSettings();

    idleTimer?.cancel();
    idleTimer = Timer(Duration(seconds: idleTime), () async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      _startIconFlashing();

      // 根据设置决定是否使用生物识别认证
      bool isAuthenticated = false;
      final prefs = await SharedPreferences.getInstance();
      final biometricAuthEnabled = prefs.getBool('biometricAuth') ?? true;

      if (biometricAuthEnabled) {
        // 使用生物识别认证
        isAuthenticated = await authProvider.authenticate();
      } else {
        // 生物识别认证已禁用，可以在这里添加其他认证方式
        // 暂时默认认证失败，让用户手动解锁
        isAuthenticated = false;
      }

      _stopIconFlashing();
      if (!isAuthenticated) {
        setState(() {});
        handleSetIcon(kIconTypeDefault);
        return;
      }

      handleSetIcon(kIconTypeOriginal);
    });
  }

  @override
  Widget build(BuildContext context) {
    isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    if (isLoggedIn) {
      handleSetIcon(kIconTypeOriginal);
    } else {
      handleSetIcon(kIconTypeDefault);
    }

    return GestureDetector(
      onTap: () => resetIdleTimer(context),
      onPanDown: (_) => resetIdleTimer(context),
      child: MaterialApp(
        navigatorKey: NavigatorKeyHolder.navigatorKey,
        theme: AppTheme.lightTheme,
        home: isLoggedIn ? MainScreen() : LockScreen(),
      ),
    );
  }
}
