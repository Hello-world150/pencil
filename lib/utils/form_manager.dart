import 'package:flutter/material.dart';
import '../models/thought_item.dart';
import '../services/thought_service.dart';
import '../utils/utils.dart';
import '../constants/app_constants.dart';

/// 想法表单管理器
class ThoughtFormManager {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController authorController;
  final TextEditingController tagController;
  
  bool _isDisposed = false;

  ThoughtFormManager({
    String? initialTitle,
    String? initialContent,
    String? initialAuthor,
    String? initialTag,
  }) : 
    titleController = TextEditingController(text: initialTitle ?? ''),
    contentController = TextEditingController(text: initialContent ?? ''),
    authorController = TextEditingController(text: initialAuthor ?? ''),
    tagController = TextEditingController(text: initialTag ?? '');

  /// 从想法项目初始化
  factory ThoughtFormManager.fromThought(ThoughtItem thought) {
    return ThoughtFormManager(
      initialTitle: thought.title ?? '',
      initialContent: thought.content,
      initialAuthor: thought.author ?? '',
      initialTag: thought.tag,
    );
  }

  /// 添加监听器
  void addListeners(VoidCallback onChanged) {
    if (_isDisposed) return;
    
    titleController.addListener(onChanged);
    contentController.addListener(onChanged);
    authorController.addListener(onChanged);
    tagController.addListener(onChanged);
  }

  /// 移除监听器
  void removeListeners(VoidCallback onChanged) {
    if (_isDisposed) return;
    
    titleController.removeListener(onChanged);
    contentController.removeListener(onChanged);
    authorController.removeListener(onChanged);
    tagController.removeListener(onChanged);
  }

  /// 清空所有输入
  void clearAll() {
    if (_isDisposed) return;
    
    titleController.clear();
    contentController.clear();
    authorController.clear();
    tagController.clear();
  }

  /// 验证表单
  FormValidationResult validate() {
    final content = contentController.text.trim();
    
    if (!Utils.isNotEmpty(content)) {
      return FormValidationResult(
        isValid: false,
        errorMessage: '想法内容不能为空',
      );
    }

    return FormValidationResult(isValid: true);
  }

  /// 获取标题（处理空字符串）
  String? get title {
    final text = titleController.text.trim();
    return text.isEmpty ? null : text;
  }

  /// 获取内容
  String get content => contentController.text.trim();

  /// 获取作者（处理空字符串）
  String? get author {
    final text = authorController.text.trim();
    return text.isEmpty ? null : text;
  }

  /// 获取标签
  String get tag => tagController.text;

  /// 检查是否有变化（用于编辑模式）
  bool hasChanges(ThoughtItem originalThought) {
    return content != originalThought.content ||
           tag != originalThought.tag ||
           title != originalThought.title ||
           author != originalThought.author;
  }

  /// 创建想法对象
  Future<ThoughtItem?> createThought(ThoughtService thoughtService) async {
    final validationResult = validate();
    if (!validationResult.isValid) {
      return null;
    }

    return await thoughtService.addThoughtAndSave(
      content: content,
      tag: tag,
      title: title,
      author: author,
    );
  }

  /// 更新想法对象
  ThoughtItem updateThought(ThoughtItem originalThought) {
    return originalThought.copyWith(
      content: content,
      tag: Utils.safeString(tag, AppConstants.defaultTag),
      title: title,
      author: author,
    );
  }

  /// 销毁资源
  void dispose() {
    if (_isDisposed) return;
    
    _isDisposed = true;
    titleController.dispose();
    contentController.dispose();
    authorController.dispose();
    tagController.dispose();
  }
}

/// 表单验证结果
class FormValidationResult {
  final bool isValid;
  final String? errorMessage;

  const FormValidationResult({
    required this.isValid,
    this.errorMessage,
  });
}
