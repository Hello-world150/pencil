import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/thought_item.dart';
import '../constants/app_constants.dart';
import '../utils/utils.dart';

/// 想法管理服务
class ThoughtService {
  final List<ThoughtItem> _thoughts = [];

  /// 获取所有想法
  List<ThoughtItem> get thoughts => List.unmodifiable(_thoughts);

  /// 获取所有已使用的标签
  List<String> get usedTags {
    final tags = <String>{};
    for (final thought in _thoughts) {
      tags.add(thought.tag);
    }
    return tags.toList()..sort();
  }

  /// 按标签分组的想法
  Map<String, List<ThoughtItem>> get groupedThoughts {
    final grouped = <String, List<ThoughtItem>>{};
    for (final thought in _thoughts) {
      if (!grouped.containsKey(thought.tag)) {
        grouped[thought.tag] = [];
      }
      grouped[thought.tag]!.add(thought);
    }
    return grouped;
  }

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
    return thought;
  }

  /// 更新想法
  bool updateThought(ThoughtItem updatedThought) {
    final index = _thoughts.indexWhere((t) => t.id == updatedThought.id);
    if (index != -1) {
      _thoughts[index] = updatedThought;
      return true;
    }
    return false;
  }

  /// 删除想法
  bool deleteThought(String id) {
    final initialLength = _thoughts.length;
    _thoughts.removeWhere((thought) => thought.id == id);
    return _thoughts.length != initialLength;
  }

  /// 删除标签及其所有想法
  int deleteThoughtsByTag(String tag) {
    final thoughtsToDelete = _thoughts.where((thought) => thought.tag == tag).toList();
    _thoughts.removeWhere((thought) => thought.tag == tag);
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
    
    return count;
  }

  /// 检查是否为空
  bool get isEmpty => _thoughts.isEmpty;

  /// 获取想法总数
  int get count => _thoughts.length;

  /// 从本地存储加载想法数据
  Future<bool> loadThoughts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(AppConstants.storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return true; // 首次使用，没有数据是正常的
      }
      
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final List<ThoughtItem> loadedThoughts = jsonList
          .map((json) => ThoughtItem.fromMap(json as Map<String, dynamic>))
          .toList();
      
      _thoughts.clear();
      _thoughts.addAll(loadedThoughts);
      
      return true;
    } catch (e) {
      // 加载失败，保持现有数据
      return false;
    }
  }

  /// 保存想法数据到本地存储
  Future<bool> saveThoughts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList = 
          _thoughts.map((thought) => thought.toMap()).toList();
      final String jsonString = jsonEncode(jsonList);
      
      await prefs.setString(AppConstants.storageKey, jsonString);
      return true;
    } catch (e) {
      // 保存失败
      return false;
    }
  }

  /// 添加新想法（带自动保存）
  Future<ThoughtItem?> addThoughtAndSave({
    required String content,
    String? tag,
  }) async {
    final thought = addThought(content: content, tag: tag);
    final success = await saveThoughts();
    return success ? thought : null;
  }

  /// 更新想法（带自动保存）
  Future<bool> updateThoughtAndSave(ThoughtItem updatedThought) async {
    final success = updateThought(updatedThought);
    if (success) {
      return await saveThoughts();
    }
    return false;
  }

  /// 删除想法（带自动保存）
  Future<bool> deleteThoughtAndSave(String id) async {
    final success = deleteThought(id);
    if (success) {
      return await saveThoughts();
    }
    return false;
  }

  /// 删除标签及其所有想法（带自动保存）
  Future<int> deleteThoughtsByTagAndSave(String tag) async {
    final count = deleteThoughtsByTag(tag);
    if (count > 0) {
      await saveThoughts();
    }
    return count;
  }

  /// 重命名标签（带自动保存）
  Future<int> renameTagAndSave(String oldTag, String newTag) async {
    final count = renameTag(oldTag, newTag);
    if (count > 0) {
      await saveThoughts();
    }
    return count;
  }
}
