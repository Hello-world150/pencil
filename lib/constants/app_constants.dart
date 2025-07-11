/// 应用常量定义 - 集中管理所有配置常量
class AppConstants {
  // 私有构造函数，防止实例化
  AppConstants._();
  
  // ========== 应用信息 ==========
  
  /// 应用名称
  static const String appName = 'Pencil';
  
  // ========== 默认配置 ==========
  
  /// 默认标签名称
  static const String defaultTag = '想法';
  
  /// 默认字体族 - 思源宋体
  static const String fontFamily = 'Source Han Serif SC';
  
  /// 本地存储键名
  static const String storageKey = 'pencil_thoughts';
  
  // ========== UI 样式配置 ==========
  
  /// 默认内边距
  static const double defaultPadding = 16.0;
  
  /// 卡片阴影高度
  static const double cardElevation = 2.0;
  
  /// 边框圆角半径
  static const double borderRadius = 12.0;
  
  // ========== 文本显示约束 ==========
  
  /// 预览模式最大行数
  static const int maxPreviewLines = 3;
  
  /// 文本输入框默认行数
  static const int defaultTextFieldLines = 3;
  
  /// 文本输入框最大行数
  static const int maxTextFieldLines = 5;
  
  // ========== 动画和时长配置 ==========
  
  /// 提示条显示时长
  static const Duration snackBarDuration = Duration(seconds: 2);
  
  // ========== 用户界面文案 ==========
  
  /// 想法输入提示
  static const String thoughtHint = '想法...';
  
  /// 标签输入标签
  static const String tagLabel = '标签（可选）';
  
  /// 空状态提示消息
  static const String emptyStateMessage = '还没有想法，开始记录吧！';
  
  /// 无标签提示消息
  static const String noTagsMessage = '暂无可用标签';
  
  /// 选择标签提示
  static const String quickSelectTagsHint = '选择标签：';
  
  // ========== 操作按钮提示文本 ==========
  
  /// 保存按钮提示
  static const String saveTooltip = '保存';
  
  /// 编辑想法按钮提示
  static const String editTooltip = '编辑想法';
  
  /// 删除想法按钮提示
  static const String deleteTooltip = '删除想法';
  
  /// 删除标签按钮提示
  static const String deleteTagTooltip = '删除整个标签';
  
  /// 编辑标签按钮提示
  static const String editTagTooltip = '编辑标签';
  
  // ========== 标签管理相关文案 ==========
  
  /// 重命名标签对话框标题
  static const String renameTag = '重命名标签';
  
  /// 新标签名称输入标签
  static const String newTagName = '新标签名称';
  
  /// 标签重命名成功提示
  static const String tagRenamed = '标签已重命名';
  
  /// 标签重命名输入提示
  static const String tagRenameHint = '新的标签名称...';
  
  // ========== 对话框按钮文本 ==========
  
  /// 删除按钮文本
  static const String deleteButton = '删除';
  
  /// 取消按钮文本
  static const String cancelButton = '取消';
  
  /// 重命名按钮文本
  static const String renameButton = '重命名';
  
  /// 确认按钮文本
  static const String confirmButton = '确认';
  
  // ========== 状态消息文案 ==========
  
  /// 想法保存成功消息
  static const String thoughtSaved = '想法已保存到';
  
  /// 想法删除成功消息
  static const String thoughtDeleted = '想法已删除';
  
  /// 想法更新成功消息
  static const String thoughtUpdated = '想法已更新';
  
  /// 数据加载失败消息
  static const String dataLoadFailed = '数据加载失败';
  
  /// 数据保存失败消息
  static const String dataSaveFailed = '数据保存失败';
  
  // ========== 确认对话框文案 ==========
  
  /// 删除确认标题
  static const String deleteConfirmTitle = '确认删除';
  
  /// 确认删除对话框标题
  static const String confirmDelete = '确认删除';
  
  /// 删除想法确认消息
  static const String deleteThoughtConfirm = '确定要删除这条想法吗？';
  
  /// 确认删除想法消息
  static const String confirmDeleteThought = '确定要删除这条想法吗？';
  
  /// 删除标签确认消息
  static const String deleteTagConfirm = '确定要删除这个标签及其所有想法吗？';
  
  /// 确认删除标签消息
  static const String confirmDeleteTag = '确定要删除这个标签及其所有想法吗？';
}
