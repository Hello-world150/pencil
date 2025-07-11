import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/thought_item.dart';
import '../services/thought_service.dart';
import '../widgets/common_widgets.dart';
import '../pages/tag_detail_page.dart';

/// 标签列表页面 - 专注于展示标签列表和管理
class TagListPage extends StatefulWidget {
  /// 想法服务实例
  final ThoughtService? thoughtService;
  
  const TagListPage({super.key, this.thoughtService});

  @override
  TagListPageState createState() => TagListPageState();
}

class TagListPageState extends State<TagListPage> {
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
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: _buildContent(),
      ),
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
    
    return _buildTagsList();
  }

  /// 构建标签列表
  Widget _buildTagsList() {
    final entries = _thoughtService.groupedThoughts.entries.toList();
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildTagListItem(entry.key, entry.value);
      },
    );
  }

  /// 构建标签列表项
  Widget _buildTagListItem(String tag, List<ThoughtItem> thoughts) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: AppConstants.cardElevation,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ListTile(
        onTap: () => _navigateToTagDetail(tag, thoughts),
        leading: _buildTagIcon(tag),
        title: _buildTagTitle(tag),
        subtitle: _buildTagSubtitle(thoughts.length),
        trailing: _buildTagActions(tag),
      ),
    );
  }

  /// 构建标签图标
  Widget _buildTagIcon(String tag) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag.isNotEmpty ? tag[0].toUpperCase() : '#',
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 构建标签标题
  Widget _buildTagTitle(String tag) {
    return Text(
      tag,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }

  /// 构建标签副标题
  Widget _buildTagSubtitle(int thoughtCount) {
    return Text(
      '$thoughtCount 条想法',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
      ),
    );
  }

  /// 构建标签操作按钮
  Widget _buildTagActions(String tag) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => _editTag(tag),
          tooltip: '编辑标签',
          iconSize: 20,
        ),
        IconButton(
          icon: const Icon(Icons.delete_sweep),
          onPressed: () => _deleteTag(tag),
          tooltip: '删除标签及所有想法',
          iconSize: 20,
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }

  // ========== 想法操作方法 ==========

  /// 删除标签及其所有想法
  Future<void> _deleteTag(String tag) async {
    final thoughtCount = _thoughtService.groupedThoughts[tag]?.length ?? 0;
    
    if (!await _showDeleteTagConfirmation(tag, thoughtCount)) return;
    
    final deletedCount = await _thoughtService.deleteThoughtsByTagAndSave(tag);
    setState(() {});
    _showMessage('标签"$tag"及其 $deletedCount 条想法已删除！');
  }

  /// 显示删除标签确认对话框
  Future<bool> _showDeleteTagConfirmation(String tag, int thoughtCount) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: _buildDeleteConfirmContent(tag, thoughtCount),
        actions: _buildDeleteConfirmActions(),
      ),
    ) ?? false;
  }

  /// 构建删除确认对话框内容
  Widget _buildDeleteConfirmContent(String tag, int thoughtCount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('确定要删除标签"$tag"吗？'),
        const SizedBox(height: 8),
        Text(
          '这将同时删除该标签下的 $thoughtCount 条想法，此操作无法撤销。',
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// 构建删除确认对话框按钮
  List<Widget> _buildDeleteConfirmActions() {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('取消'),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(true),
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
        ),
        child: const Text('删除'),
      ),
    ];
  }

  /// 编辑标签
  void _editTag(String tag) {
    showDialog<void>(
      context: context,
      builder: (context) => TagEditDialog(
        currentTag: tag,
        onTagRenamed: (newTag) => _handleTagRename(tag, newTag),
      ),
    );
  }

  /// 处理标签重命名
  Future<void> _handleTagRename(String oldTag, String newTag) async {
    final count = await _thoughtService.renameTagAndSave(oldTag, newTag);
    if (count > 0) {
      setState(() {});
      _showMessage('标签"$oldTag"已重命名为"$newTag"，影响了 $count 条想法');
    }
  }

  // ========== 页面导航方法 ==========

  /// 导航到标签详情页面
  void _navigateToTagDetail(String tag, List<ThoughtItem> thoughts) {
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) => TagDetailPage(
            tag: tag,
            thoughts: thoughts,
            thoughtService: _thoughtService,
          ),
        ))
        .then((_) => refreshData());
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
