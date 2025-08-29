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
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:password_manager/data/models/password_entry.dart';
import 'package:password_manager/utils/helpers/encryption_util.dart';
import 'package:path_provider/path_provider.dart';

class PasswordRepository {
  final _prefs = SharedPreferences.getInstance();
  final _encryptionUtil = EncryptionUtil();

  // 初始化加密工具
  Future<void> initialize() async {
    await _encryptionUtil.initialize();
  }

  Future<List<PasswordEntry>> loadPasswords() async {
    print('——— Repository.loadPasswords 被调用 ———');
    final prefs = await _prefs;
    final passwordsJson = prefs.getStringList('passwords') ?? [];
    print('从存储加载的JSON条数: ${passwordsJson.length}');

    return passwordsJson.map((json) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        print('解析JSON: ID=${map['id']}, tags=${map['tags']}');

        // 使用fromMap方法确保所有字段（包括tags）都被正确处理
        final entry = PasswordEntry.fromMap(map);

        // 根据类型解密相应的字段
        if (_typeNeedsPasswordValidation(entry.type)) {
          final encryptedFields = _getEncryptedFields(entry.type);
          var decryptedEntry = entry;

          for (final fieldKey in encryptedFields) {
            final encryptedValue = entry.fields[fieldKey] as String? ?? '';
            if (encryptedValue.isNotEmpty) {
              try {
                final decryptedValue = _encryptionUtil.decrypt(encryptedValue);
                decryptedEntry = decryptedEntry.updateField(
                  fieldKey,
                  decryptedValue,
                );
              } catch (e) {
                // 如果解密失败，保持原值
                print('解密字段 $fieldKey 失败: $e');
              }
            }
          }

          print('解密完成后的标签: ${decryptedEntry.tags}');
          return decryptedEntry;
        }

        print('无需解密，返回条目标签: ${entry.tags}');
        return entry;
      } catch (e) {
        print("Error parsing password: $e");
        return PasswordEntry(
          id: DateTime.now().toString(),
          title: "解析失败",
          type: PasswordEntryType.login,
          fields: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    }).toList();
  }

  // 获取所有密码（修复解密逻辑）
  Future<List<PasswordEntry>> getAllDecryptedPasswords() async {
    final prefs = await _prefs;
    final passwordsJson = prefs.getStringList('passwords') ?? [];

    return passwordsJson.map((json) {
      try {
        // 1. 正确解析JSON（确保格式正确）
        final map = jsonDecode(json) as Map<String, dynamic>;
        final entry = PasswordEntry.fromMap(map);

        // 2. 根据类型解密相应的字段
        if (_typeNeedsPasswordValidation(entry.type)) {
          final encryptedFields = _getEncryptedFields(entry.type);
          var decryptedEntry = entry;

          for (final fieldKey in encryptedFields) {
            final encryptedValue = entry.fields[fieldKey] as String? ?? '';
            if (encryptedValue.isNotEmpty) {
              try {
                final decryptedValue = _encryptionUtil.decrypt(encryptedValue);
                decryptedEntry = decryptedEntry.updateField(
                  fieldKey,
                  decryptedValue,
                );
              } catch (e) {
                // 如果解密失败，保持原值
                print('解密字段 $fieldKey 失败: $e');
              }
            }
          }

          return decryptedEntry;
        }

        return entry;
      } catch (e) {
        // 处理单条数据解析失败（不影响其他数据）
        print('解析密码失败: $e');
        return PasswordEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: '解析失败',
          type: PasswordEntryType.login,
          fields: {'username': '', 'password': ''},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    }).toList();
  }

  Future<List<PasswordEntry>> getAllEncryptedPasswords() async {
    final prefs = await _prefs;
    final passwordsJson = prefs.getStringList('passwords') ?? [];
    return passwordsJson.map<PasswordEntry>((json) {
      // 1. 正确解析JSON（确保格式正确）
      final map = jsonDecode(json) as Map<String, dynamic>;

      // 2. 正确获取加密密码：先从fields中获取，再从根级别获取
      final fields = map['fields'] as Map<String, dynamic>? ?? {};
      final encryptedPassword =
          fields['password'] as String? ?? map['password'] as String? ?? '';

      if (encryptedPassword.isEmpty) {
        final entry = PasswordEntry.fromMap(map);
        return entry.updateField('password', '');
      }
      return PasswordEntry.fromMap(map);
    }).toList();
  }

  // 保存密码（确保加密后的数据完整存储）
  Future<void> savePassword(PasswordEntry password) async {
    final prefs = await _prefs;
    final allPasswords = await getAllEncryptedPasswords();

    // 根据密码类型加密相应的字段
    var passwordToSave = password.copyWith(
      updatedAt: DateTime.now(),
      createdAt: password.createdAt ?? DateTime.now(),
    );

    // 如果需要加密字段，对所有加密字段进行加密
    if (_typeNeedsPasswordValidation(password.type)) {
      final encryptedFields = _getEncryptedFields(password.type);

      for (final fieldKey in encryptedFields) {
        final fieldValue = password.fields[fieldKey] ?? '';
        if (fieldValue.isNotEmpty) {
          final encryptedValue = _encryptionUtil.encrypt(fieldValue);
          passwordToSave = passwordToSave.updateField(fieldKey, encryptedValue);
        }
      }
    }

    // 更新列表并保存
    final index = allPasswords.indexWhere((p) => p.id == password.id);
    if (index != -1) {
      allPasswords[index] = passwordToSave;
    } else {
      allPasswords.add(passwordToSave);
    }

    // 存储JSON字符串列表（确保完整）
    final passwordsJson = allPasswords
        .map((p) => jsonEncode(p.toMap()))
        .toList();
    await prefs.setStringList('passwords', passwordsJson);
  }

  // 调试方法：检查存储数据的状态
  Future<void> debugStorageStatus() async {
    final prefs = await _prefs;
    final passwordsJson = prefs.getStringList('passwords') ?? [];

    print('=== 存储数据调试信息 ===');
    print('总数据条数: ${passwordsJson.length}');

    // 检查所有可能的存储键
    final allKeys = prefs.getKeys();
    print('所有存储键: $allKeys');

    // 检查是否有其他名称的密码数据
    for (final key in allKeys) {
      if (key.contains('password') ||
          key.contains('vault') ||
          key.contains('data')) {
        final value = prefs.get(key);
        print(
          '找到相关键: $key = ${value.toString().substring(0, math.min(100, value.toString().length))}...',
        );
      }
    }

    for (int i = 0; i < passwordsJson.length; i++) {
      final json = passwordsJson[i];
      print('\n条目 $i:');
      print('原始数据: ${json.substring(0, math.min(100, json.length))}...');

      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        print('解析成功 - ID: ${map['id']}, 标题: ${map['title']}');
      } catch (e) {
        print('解析失败: $e');
      }
    }
    print('=== 调试信息结束 ===\n');
  }

  // 修复损坏的数据
  Future<void> repairCorruptedData() async {
    final prefs = await _prefs;
    final passwordsJson = prefs.getStringList('passwords') ?? [];

    // 过滤掉损坏的数据
    final validPasswords = <PasswordEntry>[];

    for (final json in passwordsJson) {
      try {
        // 尝试解析JSON
        final map = jsonDecode(json) as Map<String, dynamic>;

        // 验证必要字段
        if (map.containsKey('id') &&
            map.containsKey('title') &&
            map.containsKey('type')) {
          // 根据密码类型确定是否需要密码验证
          final type = PasswordEntryType.values.firstWhere(
            (e) => e.toString() == map['type'],
            orElse: () => PasswordEntryType.login,
          );

          final needsPasswordValidation = _typeNeedsPasswordValidation(type);

          if (!needsPasswordValidation) {
            // 对于不需要密码验证的类型（如身份标识、安全笔记），直接创建条目
            final entry = PasswordEntry.fromMap(map);
            validPasswords.add(entry);
            print('验证成功 - ID: ${map['id']}, 标题: ${map['title']} (无需密码验证)');
          } else {
            // 对于需要密码验证的类型，检查所有可能的加密字段
            final fields = map['fields'] as Map<String, dynamic>? ?? {};
            final encryptedFields = _getEncryptedFields(type);
            bool hasValidEncryptedField = false;

            // 检查是否至少有一个有效的加密字段
            for (final fieldKey in encryptedFields) {
              final fieldValue = fields[fieldKey] as String? ?? '';
              if (fieldValue.isNotEmpty) {
                try {
                  // 尝试解密验证数据完整性
                  final decryptedValue = _encryptionUtil.decrypt(fieldValue);
                  if (decryptedValue.isNotEmpty) {
                    hasValidEncryptedField = true;
                    break;
                  }
                } catch (decryptError) {
                  // 如果解密失败，可能是明文数据，也认为有效
                  print('字段 $fieldKey 可能是明文数据，将重新加密: $fieldValue');
                  hasValidEncryptedField = true;
                  break;
                }
              }
            }

            if (hasValidEncryptedField) {
              // 创建PasswordEntry并解密所有加密字段
              final entry = PasswordEntry.fromMap(map);
              var validEntry = entry;

              for (final fieldKey in encryptedFields) {
                final encryptedValue = fields[fieldKey] as String? ?? '';
                if (encryptedValue.isNotEmpty) {
                  try {
                    final decryptedValue = _encryptionUtil.decrypt(
                      encryptedValue,
                    );
                    if (decryptedValue.isNotEmpty) {
                      validEntry = validEntry.updateField(
                        fieldKey,
                        decryptedValue,
                      );
                    }
                  } catch (e) {
                    // 如果解密失败，说明是明文数据，直接使用
                    print('字段 $fieldKey 是明文数据，直接使用: $encryptedValue');
                    validEntry = validEntry.updateField(
                      fieldKey,
                      encryptedValue,
                    );
                  }
                }
              }

              validPasswords.add(validEntry);
              print('验证成功 - ID: ${map['id']}, 标题: ${map['title']}');
            } else {
              print('所有加密字段都无效，跳过条目: ${map['title']}');
            }
          }
        } else {
          print('缺少必要字段，跳过条目');
        }
      } catch (parseError) {
        print('JSON解析失败，跳过损坏的数据: $parseError');
      }
    }

    // 重新保存有效数据
    if (validPasswords.isNotEmpty) {
      final repairedData = validPasswords.map((entry) {
        // 根据类型决定是否需要加密字段
        if (_typeNeedsPasswordValidation(entry.type)) {
          final encryptedFields = _getEncryptedFields(entry.type);
          var entryToSave = entry;

          for (final fieldKey in encryptedFields) {
            final fieldValue = entry.fields[fieldKey] ?? '';
            if (fieldValue.isNotEmpty) {
              final encryptedValue = _encryptionUtil.encrypt(fieldValue);
              entryToSave = entryToSave.updateField(fieldKey, encryptedValue);
            }
          }

          return jsonEncode(entryToSave.toMap());
        }
        // 对于不需要密码的类型，直接存储
        return jsonEncode(entry.toMap());
      }).toList();

      await prefs.setStringList('passwords', repairedData);
      print('数据修复完成，保存了 ${validPasswords.length} 个有效密码条目');
    } else {
      // 如果没有有效数据，清空存储
      await prefs.remove('passwords');
      print('清空了损坏的密码数据');
    }
  }

  // 判断密码类型是否需要加密字段验证
  bool _typeNeedsPasswordValidation(PasswordEntryType type) {
    switch (type) {
      case PasswordEntryType.identity: // 身份标识 - 没有加密字段
      case PasswordEntryType.secureNote: // 安全笔记 - 没有加密字段
      case PasswordEntryType.device: // 安全设备 - 密码字段可选
        return false;
      default:
        return true;
    }
  }

  // 获取每种类型需要加密的字段列表
  List<String> _getEncryptedFields(PasswordEntryType type) {
    switch (type) {
      case PasswordEntryType.login:
      case PasswordEntryType.server:
      case PasswordEntryType.database:
      case PasswordEntryType.wifi:
        return ['password'];
      case PasswordEntryType.creditCard:
        return ['cvv', 'pin'];
      case PasswordEntryType.license:
        return ['licenseKey'];
      case PasswordEntryType.identity:
      case PasswordEntryType.secureNote:
      case PasswordEntryType.device:
      default:
        return [];
    }
  }

  // 获取密码类型对应的主要密码字段名（保留兼容性）
  String _getPasswordFieldKey(PasswordEntryType type) {
    switch (type) {
      case PasswordEntryType.license:
        return 'licenseKey'; // 软件许可证使用 licenseKey
      case PasswordEntryType.creditCard:
        return 'cvv'; // 信用卡使用 cvv 作为主要加密字段
      default:
        return 'password'; // 其他类型使用 password
    }
  }

  // 删除密码
  Future<void> deletePassword(String id) async {
    final prefs = await _prefs;
    final allPasswords = await getAllEncryptedPasswords(); // 获取加密的密码列表
    allPasswords.removeWhere((p) => p.id == id);

    // 正确地存储为JSON格式
    final passwordsJson = allPasswords
        .map((p) => jsonEncode(p.toMap()))
        .toList();
    await prefs.setStringList('passwords', passwordsJson);
  }

  // 导出密码
  Future<void> exportPasswords() async {
    await _encryptionUtil.initialize();
    final allPasswords = await getAllDecryptedPasswords();
    final encryptedEntries = allPasswords.map((entry) {
      final encryptedPassword = _encryptionUtil.encrypt(entry.password);
      final entryWithEncryptedPassword = entry.updateField(
        'password',
        encryptedPassword,
      );
      return entryWithEncryptedPassword.toMap();
    }).toList();

    final jsonData = jsonEncode(encryptedEntries);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/passwords_export.json');
    await file.writeAsString(jsonData);
  }

  // 导入密码
  Future<void> importPasswords() async {
    await _encryptionUtil.initialize();
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/passwords_export.json');
    if (await file.exists()) {
      final jsonData = await file.readAsString();
      final entriesJson = jsonDecode(jsonData) as List<dynamic>;

      final newPasswords = entriesJson.map((json) {
        final map = json as Map<String, dynamic>;
        final encryptedPassword = map['password'];
        final decryptedPassword = _encryptionUtil.decrypt(encryptedPassword);
        final entry = PasswordEntry.fromMap(map);
        return entry.updateField('password', decryptedPassword);
      }).toList();

      final prefs = await _prefs;
      final allPasswords = await getAllDecryptedPasswords();
      allPasswords.addAll(newPasswords);

      final passwordsJson = allPasswords.map((p) {
        final encryptedPassword = _encryptionUtil.encrypt(p.password);
        final entryToSave = p.updateField('password', encryptedPassword);
        return jsonEncode(entryToSave.toMap());
      }).toList();
      await prefs.setStringList('passwords', passwordsJson);
    }
  }
}
