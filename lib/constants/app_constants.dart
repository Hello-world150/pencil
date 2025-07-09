/// 应用常量定义
class AppConstants {
  // 私有构造函数，防止实例化
  AppConstants._();
  
  /// 应用信息
  static const String appName = 'Pencil';
  
  /// 默认配置
  static const String defaultTag = '想法';
  static const String fontFamily = 'ZhuqueFangsong';
  static const String storageKey = 'pencil_thoughts';
  
  /// UI配置
  static const double defaultPadding = 16.0;
  static const double cardElevation = 2.0;
  static const double borderRadius = 12.0;
  
  /// 文本约束
  static const int maxPreviewLines = 3;
  static const int defaultTextFieldLines = 3;
  static const int maxTextFieldLines = 5;
  
  /// 动画时长
  static const Duration snackBarDuration = Duration(seconds: 2);
  
  /// 用户界面文案
  static const String thoughtHint = '在这里写下你的想法...';
  static const String tagHint = '为你的想法添加标签...';
  static const String tagLabel = '标签（可选）';
  static const String emptyStateMessage = '还没有想法，开始记录吧！';
  static const String noTagsMessage = '暂无可用标签';
  static const String quickSelectTagsHint = '快速选择已有标签：';
  
  /// 操作提示
  static const String saveTooltip = '保存';
  static const String editTooltip = '编辑想法';
  static const String deleteTooltip = '删除想法';
  static const String deleteTagTooltip = '删除整个标签';
  static const String editTagTooltip = '编辑标签';
  
  /// 标签编辑相关
  static const String renameTag = '重命名标签';
  static const String newTagName = '新标签名称';
  static const String tagRenamed = '标签已重命名';
  static const String tagRenameHint = '输入新的标签名称...';
  
  /// 对话框按钮
  static const String deleteButton = '删除';
  static const String cancelButton = '取消';
  static const String confirmButton = '确认';
  
  /// 确认对话框
  static const String confirmDelete = '确认删除';
  static const String confirmDeleteThought = '确定要删除这条想法吗？\n\n此操作无法撤销。';
  static const String confirmDeleteTag = '此操作无法撤销。';
  
  /// 操作结果消息
  static const String thoughtSaved = '想法已保存到';
  static const String thoughtUpdated = '想法已更新！';
  static const String thoughtDeleted = '想法已删除！';
  
  /// 数据持久化消息
  static const String dataLoaded = '数据已加载';
  static const String dataSaved = '数据已保存';
  static const String dataLoadFailed = '数据加载失败，请重启应用重试';
  static const String dataSaveFailed = '数据保存失败，请重试';
}
