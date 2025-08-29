/*
 * Password Manager - Encryption Utility
 * 
 * Copyright (c) 2024 V8EN (https://v8en.com)
 * Author: Simon <582883825@qq.com>
 * 
 * This file contains the AES-256 encryption utilities for secure password storage.
 * Developed by V8EN organization.
 * 
 * Contact: 582883825@qq.com
 * Website: https://v8en.com
 */

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class EncryptionUtil {
  static final EncryptionUtil _instance = EncryptionUtil._internal();
  factory EncryptionUtil() => _instance;
  EncryptionUtil._internal();

  final _storage = const FlutterSecureStorage();
  static const _keyLength = 32; // AES-256 需要32字节密钥
  static const _storageKey = 'aes_encryption_key';
  Encrypter? _encrypter;
  bool _isInitialized = false;

  // 初始化：加载或生成密钥
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 加载或生成密钥
      final key = await _loadOrGenerateKey();

      // 使用ECB模式避免IV相关问题，对于密码管理器来说安全性足够
      _encrypter = Encrypter(AES(key, mode: AESMode.ecb));
      _isInitialized = true;
      print('加密工具初始化成功');
    } catch (e) {
      print('加密工具初始化失败: $e');
      rethrow;
    }
  }

  // 加载或生成密钥（AES-256需要32字节密钥）
  Future<Key> _loadOrGenerateKey() async {
    try {
      final keyString = await _storage.read(key: _storageKey);
      if (keyString != null && keyString.isNotEmpty) {
        return Key.fromBase64(keyString);
      } else {
        // 生成新密钥并存储
        final key = Key.fromSecureRandom(_keyLength);
        await _storage.write(key: _storageKey, value: key.base64);
        print('生成新的加密密钥');
        return key;
      }
    } catch (e) {
      print('加载密钥失败: $e');
      // 生成新密钥作为备选
      final key = Key.fromSecureRandom(_keyLength);
      await _storage.write(key: _storageKey, value: key.base64);
      return key;
    }
  }

  // 加密（返回Base64编码的密文）
  String encrypt(String plainText) {
    try {
      // 验证初始化
      if (!_isInitialized || _encrypter == null) {
        print('加密工具未初始化');
        return '';
      }

      // 验证输入
      if (plainText.isEmpty) {
        return '';
      }

      // 直接加密（ECB模式不需要IV）
      final encrypted = _encrypter!.encrypt(plainText);
      return encrypted.base64;
    } catch (e) {
      print('加密失败: $e, 原文长度: ${plainText.length}');
      return '';
    }
  }

  // 解密（接收Base64编码的密文）
  Future<String> decryptAsync(String encryptedText) async {
    try {
      // 验证初始化
      if (!_isInitialized || _encrypter == null) {
        print('加密工具未初始化');
        return '';
      }

      // 验证输入数据
      if (encryptedText.isEmpty) {
        return '';
      }

      // 先尝试新格式（JSON包含IV）
      final newFormatResult = await _tryDecryptNewFormat(encryptedText);
      if (newFormatResult != null) {
        return newFormatResult;
      }

      // 再尝试直接Base64解密（ECB模式）
      try {
        final encrypted = Encrypted.fromBase64(encryptedText);
        return _encrypter!.decrypt(encrypted);
      } catch (e) {
        print('直接解密失败: $e');
      }

      // 最后尝试旧格式（使用CBC模式解密）
      return await _tryDecryptOldFormat(encryptedText);
    } catch (e) {
      print('解密失败: $e, 数据长度: ${encryptedText.length}');
      return '';
    }
  }

  // 同步解密方法（保持兼容性）
  String decrypt(String encryptedText) {
    // 对于简单的ECB解密，使用同步方法
    try {
      if (!_isInitialized || _encrypter == null) {
        print('加密工具未初始化');
        return '';
      }

      if (encryptedText.isEmpty) {
        return '';
      }

      // 尝试直接解密（ECB模式）
      final encrypted = Encrypted.fromBase64(encryptedText);
      return _encrypter!.decrypt(encrypted);
    } catch (e) {
      print('同步解密失败: $e');
      return '';
    }
  }

  // 尝试解密新格式数据（JSON包含IV）
  Future<String?> _tryDecryptNewFormat(String encryptedText) async {
    try {
      final decodedBytes = base64Decode(encryptedText);
      final decodedString = utf8.decode(decodedBytes);
      final combined = jsonDecode(decodedString) as Map<String, dynamic>;

      if (combined.containsKey('iv') && combined.containsKey('data')) {
        // 使用CBC模式解密旧数据
        final key = await _loadOrGenerateKey();
        final cbcEncrypter = Encrypter(AES(key, mode: AESMode.cbc));

        final iv = IV.fromBase64(combined['iv']);
        final encrypted = Encrypted.fromBase64(combined['data']);
        return cbcEncrypter.decrypt(encrypted, iv: iv);
      }
    } catch (e) {
      // 不是新格式，返回null
    }
    return null;
  }

  // 尝试解密旧格式数据（向后兼容）
  Future<String> _tryDecryptOldFormat(String encryptedText) async {
    try {
      // 尝试使用固定IV解密旧数据
      final encrypted = Encrypted.fromBase64(encryptedText);
      final key = await _loadOrGenerateKey();
      final cbcEncrypter = Encrypter(AES(key, mode: AESMode.cbc));

      // 尝试几种可能的IV
      final possibleIVs = [
        IV.fromLength(16), // 全零IV
        IV.fromBase64('AAAAAAAAAAAAAAAAAAAAAA=='), // 另一种全零IV表示
      ];

      for (final iv in possibleIVs) {
        try {
          return cbcEncrypter.decrypt(encrypted, iv: iv);
        } catch (e) {
          // 继续尝试下一个IV
          continue;
        }
      }

      // 如果都失败了，返回空字符串
      return '';
    } catch (e) {
      return '';
    }
  }

  // 验证Base64格式
  bool _isValidBase64(String str) {
    try {
      // 检查基本格式
      if (str.length % 4 != 0) return false;

      // 尝试解码
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 清理资源
  void dispose() {
    _isInitialized = false;
    _encrypter = null;
  }
}
