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
import 'package:password_manager/data/models/password_entry.dart';
import 'package:password_manager/data/repositories/password_repository.dart';

class PasswordProvider with ChangeNotifier {
  final PasswordRepository _repository = PasswordRepository();

  List<PasswordEntry> _passwords = [];

  PasswordProvider();

  List<PasswordEntry> get passwords => _passwords;

  String? _selectedPasswordId; // 记录当前选中的密码ID

  String? get selectedPasswordId => _selectedPasswordId;

  set selectedPasswordId(String? id) {
    if (_selectedPasswordId != id) {
      _selectedPasswordId = id;
      notifyListeners();
    }
  }

  Future<void> initialize() async {
    await _repository.initialize();

    // 调试：检查存储状态
    await _repository.debugStorageStatus();

    // 尝试修复损坏的数据（现在逻辑已经修复）
    try {
      await _repository.repairCorruptedData();
    } catch (e) {
      print('数据修复失败: $e');
    }

    _passwords = await _repository.loadPasswords();
    notifyListeners();
  }

  Future<List<PasswordEntry>> getAllDecryptedPasswords() async {
    _passwords = await _repository.getAllDecryptedPasswords();
    notifyListeners();
    return _passwords;
  }

  Future<List<PasswordEntry>> getAllEncryptedPasswords() async {
    _passwords = await _repository.getAllEncryptedPasswords();
    notifyListeners();
    return _passwords;
  }

  Future<void> savePassword(PasswordEntry password) async {
    print('——— PasswordProvider.savePassword 被调用 ———');
    print('接收到的密码对象标签: ${password.tags}');
    await _repository.savePassword(password);

    print('密码保存完成，开始重新加载...');
    _passwords = await _repository.loadPasswords();
    print('保存后重新加载的密码数量: ${_passwords.length}');

    // 查找对应的密码并打印其标签
    final savedPassword = _passwords.firstWhere(
      (p) => p.id == password.id,
      orElse: () => password,
    );
    print('保存后的密码标签: ${savedPassword.tags}');

    // 检查所有密码的标签情况
    print('=== 所有密码的标签情况 ===');
    for (int i = 0; i < _passwords.length; i++) {
      final pwd = _passwords[i];
      print('密码 $i: ID=${pwd.id}, 标题=${pwd.title}, 标签=${pwd.tags}');
    }
    print('=== 标签检查结束 ===');

    print('——— PasswordProvider.savePassword 结束 ———\n');
    notifyListeners();
  }

  Future<void> deletePassword(String id) async {
    await _repository.deletePassword(id);
    _passwords = await _repository.loadPasswords();
    notifyListeners();
  }

  Future<void> importPasswords() async {
    await _repository.importPasswords();
    _passwords = await _repository.loadPasswords();
    notifyListeners();
  }

  Future<void> exportPasswords() async {
    await _repository.exportPasswords();
  }

  // 切换密码的收藏状态
  Future<void> toggleFavorite(String passwordId) async {
    print('——— PasswordProvider.toggleFavorite 被调用 ———');
    print('切换收藏状态的密码ID: $passwordId');

    final passwordIndex = _passwords.indexWhere((p) => p.id == passwordId);
    if (passwordIndex != -1) {
      final currentPassword = _passwords[passwordIndex];
      final updatedPassword = currentPassword.copyWith(
        isFavorite: !currentPassword.isFavorite,
        updatedAt: DateTime.now(),
      );

      print(
        '密码 "${currentPassword.title}" 收藏状态: ${currentPassword.isFavorite} -> ${updatedPassword.isFavorite}',
      );

      // 保存到存储
      await _repository.savePassword(updatedPassword);

      // 更新本地列表
      _passwords[passwordIndex] = updatedPassword;

      print('收藏状态切换完成');
      print('——— PasswordProvider.toggleFavorite 结束 ———\n');

      notifyListeners();
    } else {
      print('未找到指定ID的密码: $passwordId');
    }
  }

  // 获取收藏的密码列表
  List<PasswordEntry> get favoritePasswords {
    return _passwords.where((password) => password.isFavorite).toList();
  }

  // 获取收藏密码的数量
  int get favoriteCount {
    return favoritePasswords.length;
  }

  // 获取所有标签（去重并排序）
  List<String> get allTags {
    final tagSet = <String>{};
    for (final password in _passwords) {
      tagSet.addAll(password.tags);
    }
    final sortedTags = tagSet.toList()..sort();
    return sortedTags;
  }

  // 获取带有特定标签的密码列表
  List<PasswordEntry> getPasswordsByTag(String tag) {
    return _passwords.where((password) => password.tags.contains(tag)).toList();
  }

  // 获取标签数量统计
  Map<String, int> get tagCounts {
    final counts = <String, int>{};
    for (final password in _passwords) {
      for (final tag in password.tags) {
        counts[tag] = (counts[tag] ?? 0) + 1;
      }
    }
    return counts;
  }
}
