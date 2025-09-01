/*
 * Password Manager - Authentication Service
 * 
 * Copyright (c) 2024 V8EN (https://v8en.com)
 * Author: Simon <582883825@qq.com>
 * 
 * This file contains the authentication service for the Password Manager application.
 * Developed by V8EN organization.
 * 
 * Contact: 582883825@qq.com
 * Website: https://v8en.com
 */
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _localAuth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();

  // 存储主密码的键
  static const String _masterPasswordKey = 'master_password_hash';

  // 检查是否已设置主密码
  Future<bool> isMasterPasswordSet() async {
    final passwordHash = await _storage.read(key: _masterPasswordKey);
    return passwordHash != null && passwordHash.isNotEmpty;
  }

  // 设置主密码
  Future<void> setMasterPassword(String password) async {
    if (password.isEmpty) {
      throw Exception('密码不能为空');
    }

    // 对密码进行哈希处理后存储
    final hashedPassword = _hashPassword(password);
    await _storage.write(key: _masterPasswordKey, value: hashedPassword);
  }

  // 验证主密码
  Future<bool> authenticateWithPassword(String password) async {
    if (password.isEmpty) {
      return false;
    }

    final storedHash = await _storage.read(key: _masterPasswordKey);

    // 如果没有设置主密码，使用默认密码"1234"
    if (storedHash == null || storedHash.isEmpty) {
      return password == '1234';
    }

    // 验证密码哈希
    final inputHash = _hashPassword(password);
    return inputHash == storedHash;
  }

  // 修改主密码
  Future<bool> changeMasterPassword(
    String currentPassword,
    String newPassword,
  ) async {
    // 首先验证当前密码
    final isAuthenticated = await authenticateWithPassword(currentPassword);
    if (!isAuthenticated) {
      return false;
    }

    // 设置新密码
    await setMasterPassword(newPassword);
    return true;
  }

  // 重置主密码（用于忘记密码的情况）
  Future<void> resetMasterPassword(String newPassword) async {
    // 设置新密码
    await setMasterPassword(newPassword);
  }

  // 对密码进行哈希处理
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // 生物识别认证
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

  // 检查生物识别是否可用
  Future<bool> isBiometricAvailable() async {
    final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
    return canAuthenticateWithBiometrics ||
        await _localAuth.isDeviceSupported();
  }
}
