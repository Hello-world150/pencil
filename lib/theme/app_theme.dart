import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// 应用主题配置
class AppTheme {
  /// 主题色
  static const Color seedColor = Colors.blueAccent;
  
  /// 行高因子
  static const double textHeightFactor = 1.2;
  
  /// 获取亮色主题
  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(seedColor: seedColor);
    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: AppConstants.fontFamily,
      textTheme: const TextTheme().apply(
        fontFamily: AppConstants.fontFamily,
        heightFactor: textHeightFactor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
      ),
      useMaterial3: true,
    );
  }

  /// 获取暗色主题
  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: AppConstants.fontFamily,
      textTheme: const TextTheme().apply(
        fontFamily: AppConstants.fontFamily,
        heightFactor: textHeightFactor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
      ),
      useMaterial3: true,
    );
  }
}
