import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/thought_item.dart';
import '../widgets/common_widgets.dart';
import '../utils/utils.dart';

/// 想法卡片组件
class ThoughtCard extends StatelessWidget {
  final ThoughtItem thought;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ThoughtCard({
    super.key,
    required this.thought,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          thought.content,
          style: const TextStyle(fontSize: 16),
          maxLines: AppConstants.maxPreviewLines,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          Utils.formatDateShort(thought.createdAt),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: AppConstants.editTooltip,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showDeleteConfirmation(context),
              tooltip: AppConstants.deleteTooltip,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ConfirmDialog.show(
      context: context,
      title: AppConstants.confirmDelete,
      content: AppConstants.confirmDeleteThought,
      confirmText: AppConstants.deleteButton,
      onConfirm: onDelete,
      isDestructive: true,
    );
  }
}

/// 标签分组卡片组件
class TagGroupCard extends StatelessWidget {
  final String tag;
  final List<ThoughtItem> thoughts;
  final Function(ThoughtItem) onThoughtTap;
  final Function(ThoughtItem) onThoughtEdit;
  final Function(ThoughtItem) onThoughtDelete;
  final VoidCallback onTagDelete;
  final Function(String)? onTagEdit;

  const TagGroupCard({
    super.key,
    required this.tag,
    required this.thoughts,
    required this.onThoughtTap,
    required this.onThoughtEdit,
    required this.onThoughtDelete,
    required this.onTagDelete,
    this.onTagEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.antiAlias,
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ExpansionTile(
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        shape: const Border(),
        collapsedShape: const Border(),
        title: Row(
          children: [
            Tooltip(
              message: onTagEdit != null ? '点击编辑标签' : '',
              child: GestureDetector(
                onTap: onTagEdit != null ? () => onTagEdit!(tag) : null,
                child: Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(tag),
                      if (onTagEdit != null) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.edit,
                          size: 14,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ],
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text('${thoughts.length} 条想法')),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showTagDeleteConfirmation(context),
              tooltip: AppConstants.deleteTagTooltip,
              iconSize: 20,
            ),
          ],
        ),
        children: thoughts.map((thought) {
          return ThoughtCard(
            thought: thought,
            onTap: () => onThoughtTap(thought),
            onEdit: () => onThoughtEdit(thought),
            onDelete: () => onThoughtDelete(thought),
          );
        }).toList(),
      ),
    );
  }

  void _showTagDeleteConfirmation(BuildContext context) {
    ConfirmDialog.show(
      context: context,
      title: AppConstants.confirmDelete,
      content: '确定要删除标签"$tag"及其包含的 ${thoughts.length} 条想法吗？\n\n${AppConstants.confirmDeleteTag}',
      confirmText: AppConstants.deleteButton,
      onConfirm: onTagDelete,
      isDestructive: true,
    );
  }
}
