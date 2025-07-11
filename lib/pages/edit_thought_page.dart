import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/thought_item.dart';
import '../services/thought_service.dart';
import '../widgets/common_widgets.dart';
import '../utils/utils.dart';

/// 想法编辑页面 - 提供全屏编辑和实时保存功能
class EditThoughtPage extends StatefulWidget {
  /// 要编辑的想法
  final ThoughtItem thought;
  
  /// 可用的标签列表
  final List<String> usedTags;
  
  /// 想法服务实例
  final ThoughtService thoughtService;
  
  /// 保存回调函数
  final Future<bool> Function(ThoughtItem) onSave;

  const EditThoughtPage({
    super.key,
    required this.thought,
    required this.usedTags,
    required this.thoughtService,
    required this.onSave,
  });

  @override
  State<EditThoughtPage> createState() => _EditThoughtPageState();
}

class _EditThoughtPageState extends State<EditThoughtPage> {
  late final TextEditingController _contentController;
  late final TextEditingController _tagController;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  /// 初始化文本控制器
  void _initializeControllers() {
    _contentController = TextEditingController(text: widget.thought.content);
    _tagController = TextEditingController(text: widget.thought.tag);
    
    _contentController.addListener(_onTextChanged);
    _tagController.addListener(_onTextChanged);
  }

  /// 清理文本控制器
  void _disposeControllers() {
    _contentController.removeListener(_onTextChanged);
    _tagController.removeListener(_onTextChanged);
    _contentController.dispose();
    _tagController.dispose();
  }

  void _onTextChanged() {
    final hasChanges = _contentController.text != widget.thought.content ||
                      _tagController.text != widget.thought.tag;
    
    if (hasChanges != _hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = hasChanges;
      });
    }
  }

  Future<void> _saveChanges() async {
    final newContent = _contentController.text.trim();
    final newTag = Utils.safeString(_tagController.text, AppConstants.defaultTag);
    
    if (Utils.isNotEmpty(newContent)) {
      final updatedThought = widget.thought.copyWith(
        content: newContent,
        tag: newTag,
      );
      
      final success = await widget.onSave(updatedThought);
      if (success && mounted) {
        Navigator.of(context).pop();
      } else {
        // 保存失败，显示错误信息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppConstants.dataSaveFailed),
              duration: AppConstants.snackBarDuration,
            ),
          );
        }
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;
    
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('放弃更改？'),
        content: const Text('您有未保存的更改，确定要离开吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppConstants.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('放弃'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('编辑想法'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContentEditor(),
          const SizedBox(height: 16),
          _buildTagEditor(),
          const SizedBox(height: 16),
          _buildCreationInfo(),
        ],
      ),
    );
  }

  Widget _buildContentEditor() {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _contentController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: '在这里编辑你的想法...',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagEditor() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '标签',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                hintText: '为你的想法添加标签...',
                prefixIcon: Icon(Icons.tag),
              ),
            ),
            if (widget.usedTags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '已有标签：',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              TagFilter(
                availableTags: widget.usedTags,
                selectedTag: _tagController.text,
                onTagChanged: (tag) {
                  setState(() {
                    _tagController.text = tag ?? '';
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreationInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              '创建于 ${_formatDateTime(widget.thought.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (!_hasUnsavedChanges) return null;
    
    return FloatingActionButton.extended(
      onPressed: _saveChanges,
      icon: const Icon(Icons.save_rounded),
      label: const Text('保存更改'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 3.0,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      tooltip: '保存想法更改',
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return Utils.formatDateFull(dateTime);
  }
}
