import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/thought_item.dart';
import '../services/thought_service.dart';
import '../widgets/common_widgets.dart';
import '../widgets/thought_widgets.dart';
import '../pages/edit_thought_page.dart';
import '../pages/view_thought_page.dart';

/// 想法展示主页面 - 专注于展示想法列表和管理
class HomePage extends StatefulWidget {
  /// 想法服务实例
  final ThoughtService? thoughtService;
  
  const HomePage({super.key, this.thoughtService});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final ThoughtService _thoughtService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _thoughtService = widget.thoughtService ?? ThoughtService();
    _loadData();
  }

  /// 公共方法：刷新数据
  Future<void> refreshData() async {
    setState(() => _isLoading = true);
    await _loadData();
  }

  /// 加载想法数据
  Future<void> _loadData() async {
    final success = await _thoughtService.loadThoughts();
    if (mounted) {
      setState(() => _isLoading = false);
      if (!success) {
        _showMessage(AppConstants.dataLoadFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  /// 构建主体内容
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: _buildContent(),
    );
  }

  /// 构建内容区域
  Widget _buildContent() {
    if (_thoughtService.isEmpty) {
      return const EmptyState(
        message: AppConstants.emptyStateMessage,
        icon: Icons.lightbulb_outline,
      );
    }
    
    return _buildThoughtsList();
  }

  /// 构建想法列表
  Widget _buildThoughtsList() {
    return ListView(
      children: _thoughtService.groupedThoughts.entries.map(
        (entry) => _buildTagGroup(entry.key, entry.value),
      ).toList(),
    );
  }

  /// 构建标签分组
  Widget _buildTagGroup(String tag, List<ThoughtItem> thoughts) {
    return TagGroupCard(
      tag: tag,
      thoughts: thoughts,
      onThoughtTap: _viewThought,
      onThoughtEdit: _editThought,
      onThoughtDelete: _deleteThought,
      onTagDelete: () => _deleteTag(tag),
      onTagEdit: _editTag,
    );
  }

  // ========== 想法操作方法 ==========

  /// 删除想法
  Future<void> _deleteThought(ThoughtItem thought) async {
    final success = await _thoughtService.deleteThoughtAndSave(thought.id);
    if (success) {
      setState(() {});
      _showMessage(AppConstants.thoughtDeleted);
    } else {
      _showMessage(AppConstants.dataSaveFailed);
    }
  }

  /// 删除标签及其所有想法
  Future<void> _deleteTag(String tag) async {
    final deletedCount = await _thoughtService.deleteThoughtsByTagAndSave(tag);
    setState(() {});
    _showMessage('标签"$tag"及其 $deletedCount 条想法已删除！');
  }

  /// 编辑标签
  void _editTag(String tag) {
    showDialog<void>(
      context: context,
      builder: (context) => TagEditDialog(
        currentTag: tag,
        onTagRenamed: (newTag) async {
          final count = await _thoughtService.renameTagAndSave(tag, newTag);
          if (count > 0) {
            setState(() {});
            _showMessage('标签"$tag"已重命名为"$newTag"，影响了 $count 条想法');
          }
        },
      ),
    );
  }

  // ========== 页面导航方法 ==========

  /// 查看想法详情
  void _viewThought(ThoughtItem thought) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewThoughtPage(
          thought: thought,
          onEdit: () {
            Navigator.of(context).pop();
            _editThought(thought);
          },
          onDelete: () {
            Navigator.of(context).pop();
            _deleteThought(thought);
          },
        ),
      ),
    );
  }

  /// 编辑想法
  void _editThought(ThoughtItem thought) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditThoughtPage(
          thought: thought,
          usedTags: _thoughtService.usedTags,
          thoughtService: _thoughtService,
          onSave: (updatedThought) async {
            final success = await _thoughtService.updateThoughtAndSave(updatedThought);
            if (success) {
              setState(() {});
              _showMessage(AppConstants.thoughtUpdated);
            }
            return success;
          },
        ),
      ),
    );
  }

  // ========== 工具方法 ==========

  /// 显示消息提示
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: AppConstants.snackBarDuration,
      ),
    );
  }
}
