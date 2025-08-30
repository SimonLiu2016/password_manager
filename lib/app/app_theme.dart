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

class AppTheme {
  // 现代化调色板
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color accent = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE9ECEF);
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);

  // 深色主题颜色
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCardSurface = Color(0xFF2D2D2D);
  static const Color darkDivider = Color(0xFF424242);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 深色主题渐变色
  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF2D2D2D), Color(0xFF1E1E1E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryBlue,
      primaryContainer: Color(0xFFE3F2FD),
      secondary: accent,
      secondaryContainer: Color(0xFFE0F7FA),
      background: background,
      surface: surface,
      surfaceVariant: Color(0xFFF5F5F5),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: textPrimary,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: divider,
      error: error,
    ),

    // AppBar 主题
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),

    // 卡片主题
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardSurface,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),

    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryBlue,
        elevation: 2,
        shadowColor: primaryBlue.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // 文本按钮主题
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: textSecondary),
      hintStyle: TextStyle(color: textSecondary),
    ),

    // 列表瓦片主题
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // 分割线主题
    dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),

    // 图标主题
    iconTheme: IconThemeData(color: textSecondary, size: 24),

    // 文本主题
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      labelLarge: TextStyle(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF42A5F5), // 更亮的蓝色
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF1976D2), // 主色容器
      onPrimaryContainer: Colors.white,
      secondary: Color(0xFF4DB6AC), // 青绿色作为强调色
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF00695C),
      onSecondaryContainer: Colors.white,
      background: Color(0xFF121212), // 深黑色背景
      onBackground: Colors.white,
      surface: Color(0xFF1E1E1E), // 稍亮的表面色
      onSurface: Colors.white,
      surfaceVariant: Color(0xFF2D2D2D), // 表面变体色
      onSurfaceVariant: Color(0xFFE0E0E0), // 表面变体上的文字色（更亮）
      outline: Color(0xFF616161), // 轮廓线颜色（更亮）
      outlineVariant: Color(0xFF424242),
      error: Color(0xFFFF6B6B), // 更温和的错误色
      onError: Colors.white,
      errorContainer: Color(0xFFD32F2F),
      onErrorContainer: Colors.white,
      inverseSurface: Color(0xFFE0E0E0),
      onInverseSurface: Color(0xFF121212),
      inversePrimary: Color(0xFF1976D2),
    ),

    // AppBar 主题
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E), // 与表面色一致
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent, // 防止 Material 3 的色调变化
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),

    // 卡片主题
    cardTheme: CardThemeData(
      elevation: 8, // 增加阴影深度
      shadowColor: Colors.black.withOpacity(0.6), // 加深阴影
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Color(0xFF2D2D2D), // 卡片背景色
      surfaceTintColor: Colors.transparent, // 防止 Material 3 的色调变化
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),

    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF42A5F5), // 与主色一致
        elevation: 6,
        shadowColor: Color(0xFF42A5F5).withOpacity(0.5), // 阴影色
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // 文本按钮主题
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF42A5F5), // 与主色一致
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2D2D2D), // 输入框填充色
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF616161)), // 更亮的边框
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF616161)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF42A5F5), width: 2), // 聚焦时的边框色
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFFF6B6B), width: 2), // 错误边框
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFFF6B6B), width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: Color(0xFFE0E0E0)), // 更亮的标签文字色
      hintStyle: TextStyle(color: Color(0xFFB0B0B0)), // 提示文字色
      helperStyle: TextStyle(color: Color(0xFFB0B0B0)),
      errorStyle: TextStyle(color: Color(0xFFFF6B6B)),
    ),

    // 列表瓦片主题
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textColor: Colors.white,
      iconColor: Color(0xFFE0E0E0), // 更亮的图标颜色
      tileColor: Colors.transparent,
      selectedTileColor: Color(0xFF42A5F5).withOpacity(0.2),
      selectedColor: Color(0xFF42A5F5),
    ),

    // 分割线主题
    dividerTheme: DividerThemeData(
      color: Color(0xFF424242),
      thickness: 1,
      space: 1,
    ),

    // 图标主题
    iconTheme: IconThemeData(color: Color(0xFFE0E0E0), size: 24), // 更亮的图标颜色
    // 文本主题
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14), // 更亮的正文颜色
      bodySmall: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12), // 小号文本
      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: Color(0xFFB0B0B0),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    ),

    // 开关主题
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return Color(0xFF42A5F5); // 选中时的拇指颜色
        }
        return Colors.grey; // 未选中时的拇指颜色
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return Color(0xFF42A5F5).withOpacity(0.5); // 选中时的轨道颜色
        }
        return Colors.grey.withOpacity(0.5); // 未选中时的轨道颜色
      }),
    ),

    // Scaffold 主题
    scaffoldBackgroundColor: Color(0xFF121212), // 确保脚手架背景色
    // 下拉框主题
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2D2D2D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF616161)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF616161)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF42A5F5), width: 2),
        ),
      ),
    ),

    // 对话框主题
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF2D2D2D),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // 进度条主题
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Color(0xFF42A5F5), // 进度条颜色
      circularTrackColor: Color(0xFF424242), // 圆形轨道颜色
      linearTrackColor: Color(0xFF424242), // 线性轨道颜色
    ),

    // 滚动条主题
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStateProperty.all(Color(0xFF42A5F5).withOpacity(0.7)),
      thickness: MaterialStateProperty.all(8.0),
      radius: Radius.circular(4.0),
    ),
  );

  // 自定义装饰
  static BoxDecoration get cardDecoration => BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get primaryGradientDecoration => BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withOpacity(0.3),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );

  // 深色主题装饰
  static BoxDecoration get darkCardDecoration => BoxDecoration(
    gradient: darkCardGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );
}
