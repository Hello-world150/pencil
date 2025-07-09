import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// 标签选择组件
class TagSelector extends StatelessWidget {
  final List<String> availableTags;
  final String? selectedTag;
  final ValueChanged<String> onTagSelected;
  final String emptyMessage;

  const TagSelector({
    super.key,
    required this.availableTags,
    this.selectedTag,
    required this.onTagSelected,
    this.emptyMessage = AppConstants.noTagsMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (availableTags.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          emptyMessage,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConstants.quickSelectTagsHint,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: availableTags.map((tag) {
            return ActionChip(
              label: Text(tag),
              onPressed: () => onTagSelected(tag),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 标签过滤器组件
class TagFilter extends StatelessWidget {
  final List<String> availableTags;
  final String? selectedTag;
  final ValueChanged<String?> onTagChanged;

  const TagFilter({
    super.key,
    required this.availableTags,
    this.selectedTag,
    required this.onTagChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: availableTags.map((tag) {
        final isSelected = selectedTag == tag;
        return FilterChip(
          label: Text(tag),
          selected: isSelected,
          onSelected: (selected) {
            onTagChanged(selected ? tag : null);
          },
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
          selectedColor: Theme.of(context).colorScheme.secondaryContainer,
        );
      }).toList(),
    );
  }
}

/// 标签过滤器组件 - 支持编辑
class EditableTagFilter extends StatelessWidget {
  final List<String> availableTags;
  final String? selectedTag;
  final ValueChanged<String?> onTagChanged;
  final Function(String, String)? onTagRenamed;

  const EditableTagFilter({
    super.key,
    required this.availableTags,
    this.selectedTag,
    required this.onTagChanged,
    this.onTagRenamed,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: availableTags.map((tag) {
        final isSelected = selectedTag == tag;
        return GestureDetector(
          onLongPress: onTagRenamed != null 
              ? () => _showEditDialog(context, tag)
              : null,
          child: FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tag),
                if (onTagRenamed != null && isSelected) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.edit,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ],
              ],
            ),
            selected: isSelected,
            onSelected: (selected) {
              onTagChanged(selected ? tag : null);
            },
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
            selectedColor: Theme.of(context).colorScheme.secondaryContainer,
            tooltip: onTagRenamed != null ? '长按编辑标签' : null,
          ),
        );
      }).toList(),
    );
  }

  void _showEditDialog(BuildContext context, String tag) {
    if (onTagRenamed == null) return;
    
    showDialog<void>(
      context: context,
      builder: (context) => TagEditDialog(
        currentTag: tag,
        onTagRenamed: (newTag) => onTagRenamed!(tag, newTag),
      ),
    );
  }
}

/// 确认对话框
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = AppConstants.confirmButton,
    this.cancelText = AppConstants.cancelButton,
    required this.onConfirm,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: isDestructive
              ? TextButton.styleFrom(foregroundColor: Colors.red)
              : null,
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// 显示确认对话框
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = AppConstants.confirmButton,
    String cancelText = AppConstants.cancelButton,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        isDestructive: isDestructive,
      ),
    );
  }
}

/// 空状态组件
class EmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.message,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
          ],
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: 16),
            action!,
          ],
        ],
      ),
    );
  }
}

/// 标签编辑对话框
class TagEditDialog extends StatefulWidget {
  final String currentTag;
  final Function(String) onTagRenamed;

  const TagEditDialog({
    super.key,
    required this.currentTag,
    required this.onTagRenamed,
  });

  @override
  State<TagEditDialog> createState() => _TagEditDialogState();
}

class _TagEditDialogState extends State<TagEditDialog> {
  late final TextEditingController _controller;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentTag);
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _controller.removeListener(_validateInput);
    _controller.dispose();
    super.dispose();
  }

  void _validateInput() {
    final text = _controller.text.trim();
    final isValid = text.isNotEmpty && text != widget.currentTag;
    if (isValid != _isValid) {
      setState(() {
        _isValid = isValid;
      });
    }
  }

  void _confirm() {
    final newTag = _controller.text.trim();
    if (newTag.isNotEmpty && newTag != widget.currentTag) {
      widget.onTagRenamed(newTag);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppConstants.renameTag),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: AppConstants.newTagName,
          hintText: AppConstants.tagRenameHint,
          border: const OutlineInputBorder(),
          errorText: !_isValid && _controller.text.trim().isEmpty 
              ? '标签名称不能为空' 
              : null,
        ),
        autofocus: true,
        onSubmitted: (_) => _confirm(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppConstants.cancelButton),
        ),
        TextButton(
          onPressed: _isValid ? _confirm : null,
          child: const Text(AppConstants.confirmButton),
        ),
      ],
    );
  }
}
