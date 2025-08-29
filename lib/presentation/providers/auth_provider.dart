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
import 'package:password_manager/presentation/components/authentication/auth_service.dart';

class AuthProvider with ChangeNotifier { 

  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> authenticate() async {
    _isLoggedIn = await _authService.authenticate();
    notifyListeners();
    return _isLoggedIn;
  }

  Future<bool> authenticateWithPassword(String password) async {
    _isLoggedIn = await _authService.authenticateWithPassword(password);
    notifyListeners();
    return _isLoggedIn;
  }

  Future<bool> isBiometricAvailable() async {
    return await _authService.isBiometricAvailable();
  }

  void lock() {
    _isLoggedIn = false;
    notifyListeners();
  }
}