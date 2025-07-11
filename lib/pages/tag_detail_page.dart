import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/thought_item.dart';
import '../services/thought_service.dart';
import '../pages/edit_thought_page.dart';
import '../pages/view_thought_page.dart';

/// 标签详情页面 - 展示特定标签下的所有想法
class TagDetailPage extends StatefulWidget {
  /// 标签名称
  final String tag;
  
  /// 该标签下的想法列表
  final List<ThoughtItem> thoughts;
  
  /// 想法服务实例
  final ThoughtService thoughtService;

  const TagDetailPage({
    super.key,
    required this.tag,
    required this.thoughts,
    required this.thoughtService,
  });

  @override
  State<TagDetailPage> createState() => _TagDetailPageState();
}

class _TagDetailPageState extends State<TagDetailPage> {
  late List<ThoughtItem> _thoughts;

  @override
  void initState() {
    super.initState();
    _thoughts = List.from(widget.thoughts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('${widget.tag} (${_thoughts.length})'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  /// 构建主体内容
  Widget _buildBody() {
    if (_thoughts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              '该标签下暂无想法',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _thoughts.length,
      itemBuilder: (context, index) => _buildThoughtCard(_thoughts[index]),
    );
  }

  /// 构建想法卡片
  Widget _buildThoughtCard(ThoughtItem thought) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: () => _viewThought(thought),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThoughtContent(thought),
              const SizedBox(height: 12),
              _buildThoughtFooter(thought),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建想法内容
  Widget _buildThoughtContent(ThoughtItem thought) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 显示标题（如果有）
        if (thought.title != null) ...[
          Text(
            thought.title!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
        ],
        // 显示主要内容
        Text(
          thought.content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: thought.title != null ? 3 : 4,
          overflow: TextOverflow.ellipsis,
        ),
        // 显示作者（如果有）
        if (thought.author != null) ...[
          const SizedBox(height: 8),
          Text(
            '— ${thought.author}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  /// 构建想法底部信息
  Widget _buildThoughtFooter(ThoughtItem thought) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDate(thought.createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _editThought(thought),
              icon: const Icon(Icons.edit_outlined),
              iconSize: 20,
              tooltip: AppConstants.editTooltip,
            ),
            IconButton(
              onPressed: () => _deleteThought(thought),
              icon: const Icon(Icons.delete_outline),
              iconSize: 20,
              tooltip: AppConstants.deleteTooltip,
            ),
          ],
        ),
      ],
    );
  }

  // ========== 想法操作方法 ==========

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
          usedTags: widget.thoughtService.usedTags,
          thoughtService: widget.thoughtService,
          onSave: (updatedThought) async {
            final success = await widget.thoughtService.updateThoughtAndSave(updatedThought);
            if (success) {
              setState(() {
                final index = _thoughts.indexWhere((t) => t.id == thought.id);
                if (index != -1) {
                  _thoughts[index] = updatedThought;
                }
              });
              _showMessage(AppConstants.thoughtUpdated);
            }
            return success;
          },
        ),
      ),
    );
  }

  /// 删除想法
  Future<void> _deleteThought(ThoughtItem thought) async {
    final confirmed = await _showDeleteConfirmation();
    if (confirmed == true) {
      final success = await widget.thoughtService.deleteThoughtAndSave(thought.id);
      if (success) {
        setState(() {
          _thoughts.removeWhere((t) => t.id == thought.id);
        });
        _showMessage(AppConstants.thoughtDeleted);
      } else {
        _showMessage(AppConstants.dataSaveFailed);
      }
    }
  }

  // ========== 工具方法 ==========

  /// 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return '今天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  /// 显示删除确认对话框
  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.confirmDelete),
        content: const Text(AppConstants.confirmDeleteThought),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppConstants.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppConstants.deleteButton),
          ),
        ],
      ),
    );
  }

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
