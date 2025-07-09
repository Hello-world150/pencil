/// 实用工具类
class Utils {
  /// 格式化日期时间 - 简短格式
  static String formatDateShort(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  /// 格式化日期时间 - 完整格式
  static String formatDateFull(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  /// 生成唯一ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
  
  /// 验证非空字符串
  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }
  
  /// 安全获取字符串，提供默认值
  static String safeString(String? text, String defaultValue) {
    return isNotEmpty(text) ? text!.trim() : defaultValue;
  }
}
