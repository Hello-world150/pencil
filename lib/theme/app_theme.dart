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
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      fontFamily: AppConstants.fontFamily,
      textTheme: const TextTheme().apply(
        fontFamily: AppConstants.fontFamily,
        heightFactor: textHeightFactor,
      ),
      useMaterial3: true,
    );
  }

  /// 获取暗色主题
  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      fontFamily: AppConstants.fontFamily,
      textTheme: const TextTheme().apply(
        fontFamily: AppConstants.fontFamily,
        heightFactor: textHeightFactor,
      ),
      useMaterial3: true,
    );
  }
}
