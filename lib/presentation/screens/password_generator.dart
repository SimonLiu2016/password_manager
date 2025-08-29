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
import 'package:flutter/services.dart';
import 'package:password_manager/app/app_theme.dart';
import 'dart:math';

class PasswordGenerator extends StatefulWidget {
  final Function(String) onPasswordGenerated;

  const PasswordGenerator({Key? key, required this.onPasswordGenerated})
    : super(key: key);

  @override
  State<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  int _passwordLength = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  String _generatedPassword = '';
  bool _isFirstBuild = true; // 控制首次生成时机

  // 安全随机数生成器
  final _random = Random.secure();

  @override
  void initState() {
    super.initState();
    // 不在initState中生成密码，避免构建时调用setState
  }

  @override
  Widget build(BuildContext context) {
    // 首次构建完成后生成密码
    if (_isFirstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _generatePassword();
      });
      _isFirstBuild = false;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '密码生成器',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 生成的密码
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!, width: 1.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        _generatedPassword,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: _copyToClipboard,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 密码长度
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('密码长度'), Text('$_passwordLength')],
                  ),
                  Slider(
                    value: _passwordLength.toDouble(),
                    min: 4, // 最短长度4
                    max: 64,
                    divisions: 60,
                    onChanged: (value) {
                      setState(() => _passwordLength = value.toInt());
                    },
                    onChangeEnd: (_) => _generatePassword(),
                  ),
                ],
              ),

              // 字符类型选项 - 优化间距
              Column(
                children: [
                  CheckboxListTile(
                    title: const Text('包含大写字母 (A-Z)'),
                    value: _includeUppercase,
                    onChanged: (value) {
                      setState(() => _includeUppercase = value ?? true);
                      _generatePassword();
                    },
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('包含小写字母 (a-z)'),
                    value: _includeLowercase,
                    onChanged: (value) {
                      setState(() => _includeLowercase = value ?? true);
                      _generatePassword();
                    },
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('包含数字 (0-9)'),
                    value: _includeNumbers,
                    onChanged: (value) {
                      setState(() => _includeNumbers = value ?? true);
                      _generatePassword();
                    },
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('包含特殊字符 (!@#\$等)'),
                    value: _includeSymbols,
                    onChanged: (value) {
                      setState(() => _includeSymbols = value ?? true);
                      _generatePassword();
                    },
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // 重新生成按钮 - 现代化设计
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _generatePassword,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '重新生成',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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
    );
  }

  // 生成随机密码（确保每种选中类型至少1个）
  void _generatePassword() {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_-+=[]{}|;:,.<>?';

    // 收集选中的字符类型
    final selectedCharSets = <String>[];
    if (_includeUppercase) selectedCharSets.add(uppercase);
    if (_includeLowercase) selectedCharSets.add(lowercase);
    if (_includeNumbers) selectedCharSets.add(numbers);
    if (_includeSymbols) selectedCharSets.add(symbols);

    // 确保至少有一种字符类型
    if (selectedCharSets.isEmpty) {
      selectedCharSets.add(lowercase);
    }

    // 确保密码长度不小于选中类型数量且至少为4
    final minLength = max(selectedCharSets.length, 4);
    if (_passwordLength < minLength) {
      _passwordLength = minLength;
    }

    // 每种选中类型至少1个字符
    final passwordChars = <String>[];
    for (final charSet in selectedCharSets) {
      final randomIndex = _random.nextInt(charSet.length);
      passwordChars.add(charSet[randomIndex]);
    }

    // 填充剩余字符
    final allChars = selectedCharSets.join();
    final remainingLength = _passwordLength - selectedCharSets.length;
    for (var i = 0; i < remainingLength; i++) {
      final randomIndex = _random.nextInt(allChars.length);
      passwordChars.add(allChars[randomIndex]);
    }

    // 打乱顺序
    passwordChars.shuffle(_random);

    setState(() {
      _generatedPassword = passwordChars.join();
    });
    widget.onPasswordGenerated(_generatedPassword);
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('密码已复制到剪贴板')));
  }
}
