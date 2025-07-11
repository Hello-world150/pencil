import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/thought_item.dart';
import '../constants/app_constants.dart';
import '../utils/utils.dart';

/// 想法管理服务 - 提供想法的增删改查和持久化功能
class ThoughtService {
  static const String _storageKey = AppConstants.storageKey;
  
  // 数据存储
  final List<ThoughtItem> _thoughts = [];
  
  // 性能优化缓存
  SharedPreferences? _prefs;
  List<String>? _cachedTags;
  Map<String, List<ThoughtItem>>? _cachedGroupedThoughts;
  
  // 公共访问器
  /// 获取所有想法（只读）
  List<ThoughtItem> get thoughts => List.unmodifiable(_thoughts);
  
  /// 获取已使用的标签列表（缓存优化）
  List<String> get usedTags {
    _cachedTags ??= _computeUsedTags();
    return _cachedTags!;
  }
  
  /// 按标签分组的想法（缓存优化）
  Map<String, List<ThoughtItem>> get groupedThoughts {
    _cachedGroupedThoughts ??= _computeGroupedThoughts();
    return _cachedGroupedThoughts!;
  }
  
  /// 检查是否为空
  bool get isEmpty => _thoughts.isEmpty;
  
  /// 获取想法总数
  int get count => _thoughts.length;
  
  // ========== 私有计算方法 ==========
  
  /// 计算已使用的标签
  List<String> _computeUsedTags() {
    final tags = <String>{};
    for (final thought in _thoughts) {
      tags.add(thought.tag);
    }
    return tags.toList()..sort();
  }
  
  /// 计算按标签分组的想法
  Map<String, List<ThoughtItem>> _computeGroupedThoughts() {
    final grouped = <String, List<ThoughtItem>>{};
    for (final thought in _thoughts) {
      grouped.putIfAbsent(thought.tag, () => []).add(thought);
    }
    return grouped;
  }

  /// 清除缓存
  void _clearCache() {
    _cachedTags = null;
    _cachedGroupedThoughts = null;
  }
  
  // ========== 数据操作方法 ==========

  /// 添加新想法
  ThoughtItem addThought({
    required String content,
    String? tag,
  }) {
    final thought = ThoughtItem(
      id: Utils.generateId(),
      content: content,
      tag: Utils.safeString(tag, AppConstants.defaultTag),
      createdAt: DateTime.now(),
    );
    
    _thoughts.add(thought);
    _clearCache();
    return thought;
  }

  /// 更新想法
  bool updateThought(ThoughtItem updatedThought) {
    final index = _thoughts.indexWhere((t) => t.id == updatedThought.id);
    if (index != -1) {
      _thoughts[index] = updatedThought;
      _clearCache();
      return true;
    }
    return false;
  }

  /// 删除想法
  bool deleteThought(String id) {
    final initialLength = _thoughts.length;
    _thoughts.removeWhere((thought) => thought.id == id);
    final success = _thoughts.length != initialLength;
    if (success) _clearCache();
    return success;
  }

  /// 删除标签及其所有想法
  int deleteThoughtsByTag(String tag) {
    final thoughtsToDelete = _thoughts.where((thought) => thought.tag == tag).toList();
    _thoughts.removeWhere((thought) => thought.tag == tag);
    if (thoughtsToDelete.isNotEmpty) _clearCache();
    return thoughtsToDelete.length;
  }

  /// 根据ID查找想法
  ThoughtItem? findThoughtById(String id) {
    try {
      return _thoughts.firstWhere((thought) => thought.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 重命名标签
  int renameTag(String oldTag, String newTag) {
    if (oldTag == newTag || newTag.trim().isEmpty) return 0;
    
    final cleanNewTag = newTag.trim();
    int count = 0;
    
    for (int i = 0; i < _thoughts.length; i++) {
      if (_thoughts[i].tag == oldTag) {
        _thoughts[i] = _thoughts[i].copyWith(tag: cleanNewTag);
        count++;
      }
    }
    
    if (count > 0) _clearCache();
    return count;
  }
  
  // ========== 持久化方法 ==========

  /// 获取SharedPreferences实例（缓存）
  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// 从本地存储加载想法数据
  Future<bool> loadThoughts() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return true; // 首次使用，没有数据是正常的
      }
      
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final loadedThoughts = jsonList
          .map((json) => ThoughtItem.fromMap(json as Map<String, dynamic>))
          .toList();
      
      _thoughts
        ..clear()
        ..addAll(loadedThoughts);
      _clearCache();
      
      return true;
    } catch (e) {
      // 加载失败时保持现有数据
      return false;
    }
  }

  /// 保存想法数据到本地存储
  Future<bool> saveThoughts() async {
    try {
      final prefs = await _getPrefs();
      final jsonList = _thoughts.map((thought) => thought.toMap()).toList();
      final jsonString = jsonEncode(jsonList);
      
      await prefs.setString(_storageKey, jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // ========== 组合操作方法 ==========

  /// 添加新想法并自动保存
  Future<ThoughtItem?> addThoughtAndSave({
    required String content,
    String? tag,
  }) async {
    final thought = addThought(content: content, tag: tag);
    final success = await saveThoughts();
    return success ? thought : null;
  }

  /// 更新想法并自动保存
  Future<bool> updateThoughtAndSave(ThoughtItem updatedThought) async {
    if (updateThought(updatedThought)) {
      return await saveThoughts();
    }
    return false;
  }

  /// 删除想法并自动保存
  Future<bool> deleteThoughtAndSave(String id) async {
    if (deleteThought(id)) {
      return await saveThoughts();
    }
    return false;
  }

  /// 删除标签及其所有想法并自动保存
  Future<int> deleteThoughtsByTagAndSave(String tag) async {
    final count = deleteThoughtsByTag(tag);
    if (count > 0) {
      await saveThoughts();
    }
    return count;
  }

  /// 重命名标签并自动保存
  Future<int> renameTagAndSave(String oldTag, String newTag) async {
    final count = renameTag(oldTag, newTag);
    if (count > 0) {
      await saveThoughts();
    }
    return count;
  }
}
