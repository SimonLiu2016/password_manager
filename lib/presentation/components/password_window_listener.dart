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
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

class PasswordWindowListener extends WindowListener {
  static const platform = MethodChannel('com.v8en/password_manager');

    @override
  Future<bool> onWindowClose([int? windowId]) async {

    final bool isPreventClose = await windowManager.isPreventClose();

    if (isPreventClose) {
      await windowManager.hide();
      await windowManager.setSkipTaskbar(true);
      return false;
    }

    return true;
  }
}
