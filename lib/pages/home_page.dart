import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/thought_item.dart';
import '../services/thought_service.dart';
import '../widgets/common_widgets.dart';
import '../widgets/thought_widgets.dart';
import '../pages/edit_thought_page.dart';
import '../pages/view_thought_page.dart';

/// 主页面
class HomePage extends StatefulWidget {
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

  /// 刷新数据的公共方法
  Future<void> refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 初始化时加载数据
  Future<void> _loadData() async {
    final success = await _thoughtService.loadThoughts();
    setState(() {
      _isLoading = false;
    });
    
    if (!success) {
      _showSnackBar(AppConstants.dataLoadFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: _buildThoughtsList(),
    );
  }

  Widget _buildThoughtsList() {
    return _thoughtService.isEmpty
        ? const EmptyState(
            message: AppConstants.emptyStateMessage,
            icon: Icons.lightbulb_outline,
          )
        : ListView(
            children: _thoughtService.groupedThoughts.entries.map((entry) {
              final tag = entry.key;
              final thoughts = entry.value;
              
              return TagGroupCard(
                tag: tag,
                thoughts: thoughts,
                onThoughtTap: _viewThought,
                onThoughtEdit: _editThought,
                onThoughtDelete: _deleteThought,
                onTagDelete: () => _deleteTag(tag),
                onTagEdit: _editTag,
              );
            }).toList(),
          );
  }

  Future<void> _deleteThought(ThoughtItem thought) async {
    final success = await _thoughtService.deleteThoughtAndSave(thought.id);
    if (success) {
      setState(() {});
      _showSnackBar(AppConstants.thoughtDeleted);
    } else {
      _showSnackBar(AppConstants.dataSaveFailed);
    }
  }

  Future<void> _deleteTag(String tag) async {
    final deletedCount = await _thoughtService.deleteThoughtsByTagAndSave(tag);
    setState(() {});
    _showSnackBar('标签"$tag"及其 $deletedCount 条想法已删除！');
  }

  void _editTag(String tag) {
    showDialog<void>(
      context: context,
      builder: (context) => TagEditDialog(
        currentTag: tag,
        onTagRenamed: (newTag) async {
          final count = await _thoughtService.renameTagAndSave(tag, newTag);
          if (count > 0) {
            setState(() {});
            _showSnackBar('标签"$tag"已重命名为"$newTag"，影响了 $count 条想法');
          }
        },
      ),
    );
  }

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
              _showSnackBar(AppConstants.thoughtUpdated);
            }
            return success;
          },
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: AppConstants.snackBarDuration,
      ),
    );
  }
}
