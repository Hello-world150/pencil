import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/thought_item.dart';
import '../services/thought_service.dart';
import '../services/dialog_service.dart';
import '../utils/form_manager.dart';
import '../utils/utils.dart';
import '../widgets/input_widgets.dart';
import '../widgets/common_widgets.dart';

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
  late final ThoughtFormManager _formManager;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _formManager = ThoughtFormManager.fromThought(widget.thought);
    _formManager.addListeners(_onTextChanged);
  }

  @override
  void dispose() {
    _formManager.removeListeners(_onTextChanged);
    _formManager.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasChanges = _formManager.hasChanges(widget.thought);
    
    if (hasChanges != _hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = hasChanges;
      });
    }
  }

  Future<void> _saveChanges() async {
    final validationResult = _formManager.validate();
    
    if (!validationResult.isValid) {
      if (validationResult.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationResult.errorMessage!)),
        );
      }
      return;
    }

    final updatedThought = _formManager.updateThought(widget.thought);
    final success = await widget.onSave(updatedThought);
    
    if (success && mounted) {
      Navigator.of(context).pop();
    } else {
      // 保存失败，显示错误信息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppConstants.dataSaveFailed)),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;
    
    return await DialogService.showDiscardChangesDialog(context);
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
          _buildTitleEditor(),
          const SizedBox(height: 8),
          _buildContentEditor(),
          const SizedBox(height: 16),
          _buildAuthorEditor(),
          const SizedBox(height: 16),
          _buildTagEditor(),
          const SizedBox(height: 16),
          _buildCreationInfo(),
        ],
      ),
    );
  }

  Widget _buildTitleEditor() {
    return TitleInputField(controller: _formManager.titleController);
  }

  Widget _buildAuthorEditor() {
    return AuthorInputField(controller: _formManager.authorController);
  }

  Widget _buildContentEditor() {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _formManager.contentController,
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
              controller: _formManager.tagController,
              decoration: const InputDecoration(
                hintText: '为你的想法添加标签...',
                prefixIcon: Icon(Icons.tag),
              ),
            ),
            if (widget.usedTags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '选择标签：',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              TagFilter(
                availableTags: widget.usedTags,
                selectedTag: _formManager.tagController.text,
                onTagChanged: (tag) {
                  setState(() {
                    _formManager.tagController.text = tag ?? '';
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
