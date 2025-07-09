import 'dart:developer' as developer;

/// 性能监控工具类
class PerformanceUtils {
  // 私有构造函数，防止实例化
  PerformanceUtils._();
  
  /// 测量代码执行时间
  static Future<T> measureAsync<T>(
    String name,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();
      _logPerformance(name, stopwatch.elapsedMilliseconds);
      return result;
    } catch (e) {
      stopwatch.stop();
      _logPerformance('$name (error)', stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }
  
  /// 测量同步代码执行时间
  static T measureSync<T>(
    String name,
    T Function() operation,
  ) {
    final stopwatch = Stopwatch()..start();
    try {
      final result = operation();
      stopwatch.stop();
      _logPerformance(name, stopwatch.elapsedMilliseconds);
      return result;
    } catch (e) {
      stopwatch.stop();
      _logPerformance('$name (error)', stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }
  
  /// 记录性能数据
  static void _logPerformance(String name, int milliseconds) {
    developer.log(
      'Performance: $name took ${milliseconds}ms',
      name: 'PerformanceUtils',
    );
  }
  
  /// 标记时间点
  static void markTimelineStart(String name) {
    developer.Timeline.startSync(name);
  }
  
  /// 结束时间点标记
  static void markTimelineEnd() {
    developer.Timeline.finishSync();
  }
}
