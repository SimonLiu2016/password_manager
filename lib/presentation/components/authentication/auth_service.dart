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
import 'package:local_auth/local_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _localAuth = LocalAuthentication();

  Future<bool> authenticate() async {
    final canAuthenticate = await isBiometricAvailable();

    if (!canAuthenticate) {
      debugPrint('生物识别认证不可用');
      return false;
    }

    try {
      return await _localAuth.authenticate(
        localizedReason: '请验证以访问您的密码',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint('认证错误: $e');
      return false;
    }
  }

  Future<bool> authenticateWithPassword(String password) async {
    // 这里可以添加密码验证逻辑
    // 假设验证成功返回 true，失败返回 false
    if (password == '1234') {
      // 替换为实际的密码验证逻辑
      return true;
    } else {
      debugPrint('密码验证失败');
      return false;
    }
  }

  Future<bool> isBiometricAvailable() async {
    final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
    return canAuthenticateWithBiometrics ||
        await _localAuth.isDeviceSupported();
  }
}
