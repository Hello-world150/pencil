import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/thought_item.dart';
import '../widgets/common_widgets.dart';
import '../utils/utils.dart';

/// 想法详情查看页面 - 提供全屏阅读和快捷操作
class ViewThoughtPage extends StatelessWidget {
  /// 要查看的想法
  final ThoughtItem thought;
  
  /// 编辑回调
  final VoidCallback onEdit;
  
  /// 删除回调
  final VoidCallback onDelete;

  const ViewThoughtPage({
    super.key,
    required this.thought,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('查看想法'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _showDeleteConfirmation(context),
          tooltip: AppConstants.deleteTooltip,
        ),
      ],
    );
  }

  /// 构建主体内容
  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContentDisplay(context),
          const SizedBox(height: 16),
          _buildMetaInfo(context),
        ],
      ),
    );
  }

  Widget _buildContentDisplay(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: SelectableText(
                  thought.content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.8,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTagSection(context),
            const SizedBox(height: 16),
            _buildTimeSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTagSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.tag,
              size: 20,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              '标签',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Chip(
          label: Text(thought.tag),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      ],
    );
  }

  Widget _buildTimeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 20,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              '创建时间',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _formatDateTime(thought.createdAt),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: onEdit,
      tooltip: AppConstants.editTooltip,
      elevation: 3.0,
      child: const Icon(Icons.edit),
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

  String _formatDateTime(DateTime dateTime) {
    return Utils.formatDateFull(dateTime);
  }
}
