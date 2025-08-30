/*
 * Password Manager - Language Manager
 * 
 * Copyright (c) 2024 V8EN (https://v8en.com)
 * Author: Simon <582883825@qq.com>
 * 
 * This file contains the language management functionality for the Password Manager application.
 * Developed by V8EN organization.
 * 
 * Contact: 582883825@qq.com
 * Website: https://v8en.com
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager extends ChangeNotifier {
  static const String _languageKey = 'language';
  static const String defaultLanguage = 'zh';

  Locale _currentLocale = const Locale('zh');

  Locale get currentLocale => _currentLocale;

  static final Map<String, Locale> supportedLanguages = {
    'zh': const Locale('zh'),
    'en': const Locale('en'),
  };

  static final Map<String, String> languageNames = {
    'zh': '中文',
    'en': 'English',
  };

  LanguageManager() {
    _loadLanguage();
  }

  /// 获取当前语言代码
  String get currentLanguageCode => _currentLocale.languageCode;

  /// 获取当前语言显示名称
  String get currentLanguageName => languageNames[currentLanguageCode] ?? '中文';

  /// 加载保存的语言设置
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? defaultLanguage;

      if (supportedLanguages.containsKey(languageCode)) {
        _currentLocale = supportedLanguages[languageCode]!;
      } else {
        _currentLocale = supportedLanguages[defaultLanguage]!;
      }

      notifyListeners();
    } catch (e) {
      // 如果加载失败，使用默认语言
      _currentLocale = supportedLanguages[defaultLanguage]!;
      notifyListeners();
    }
  }

  /// 切换语言
  Future<void> changeLanguage(String languageCode) async {
    if (!supportedLanguages.containsKey(languageCode)) {
      return;
    }

    if (_currentLocale.languageCode == languageCode) {
      return; // 语言没有变化
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      _currentLocale = supportedLanguages[languageCode]!;
      notifyListeners();
    } catch (e) {
      // 处理保存失败的情况
      print('Failed to save language preference: $e');
    }
  }

  /// 获取语言显示名称
  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }

  /// 获取所有支持的语言
  List<MapEntry<String, String>> get supportedLanguageEntries {
    return languageNames.entries.toList();
  }

  /// 检查是否支持指定的语言
  bool isLanguageSupported(String languageCode) {
    return supportedLanguages.containsKey(languageCode);
  }

  /// 根据系统语言设置初始语言
  Future<void> setLanguageFromSystem() async {
    final systemLocale = PlatformDispatcher.instance.locale;
    final systemLanguageCode = systemLocale.languageCode;

    if (supportedLanguages.containsKey(systemLanguageCode)) {
      await changeLanguage(systemLanguageCode);
    } else {
      // 如果系统语言不支持，使用默认语言
      await changeLanguage(defaultLanguage);
    }
  }
}
