import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/thought_item.dart';
import '../services/thought_service.dart';
import '../widgets/common_widgets.dart';
import '../widgets/thought_widgets.dart';
import '../pages/edit_thought_page.dart';
import '../pages/view_thought_page.dart';
import '../utils/utils.dart';

/// 主页面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final ThoughtService _thoughtService = ThoughtService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _textController.dispose();
    _tagController.dispose();
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
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text(AppConstants.appName),
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
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildTextEditor(),
          const SizedBox(height: 16),
          _buildTagInput(),
          const SizedBox(height: 16),
          _buildThoughtsList(),
        ],
      ),
    );
  }

  Widget _buildTextEditor() {
    return TextField(
      controller: _textController,
      maxLines: AppConstants.maxTextFieldLines,
      minLines: AppConstants.defaultTextFieldLines,
      decoration: const InputDecoration(
        hintText: AppConstants.thoughtHint,
      ),
    );
  }

  Widget _buildTagInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _tagController,
          decoration: const InputDecoration(
            labelText: AppConstants.tagLabel,
            hintText: AppConstants.tagHint,
            prefixIcon: Icon(Icons.tag),
          ),
        ),
        if (_thoughtService.usedTags.isNotEmpty) ...[
          const SizedBox(height: 8),
          TagSelector(
            availableTags: _thoughtService.usedTags,
            onTagSelected: (tag) {
              setState(() {
                _tagController.text = tag;
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildThoughtsList() {
    return Expanded(
      child: _thoughtService.isEmpty
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
            ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _saveNewThought,
      tooltip: AppConstants.saveTooltip,
      child: const Icon(Icons.save),
    );
  }

  Future<void> _saveNewThought() async {
    final content = _textController.text.trim();
    
    if (Utils.isNotEmpty(content)) {
      final thought = await _thoughtService.addThoughtAndSave(
        content: content,
        tag: _tagController.text,
      );
      
      if (thought != null) {
        setState(() {
          _textController.clear();
          _tagController.clear();
        });
        
        _showSnackBar('${AppConstants.thoughtSaved}"${thought.tag}"标签！');
      } else {
        _showSnackBar(AppConstants.dataSaveFailed);
      }
    }
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
