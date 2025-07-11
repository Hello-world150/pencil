import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/thought_service.dart';
import '../utils/utils.dart';
import '../widgets/common_widgets.dart';

/// 新增想法页面
class AddThoughtPage extends StatefulWidget {
  /// 想法服务实例
  final ThoughtService thoughtService;
  
  /// 想法添加成功后的回调
  final VoidCallback? onThoughtAdded;
  
  const AddThoughtPage({
    super.key,
    required this.thoughtService,
    this.onThoughtAdded,
  });

  @override
  State<AddThoughtPage> createState() => _AddThoughtPageState();
}

class _AddThoughtPageState extends State<AddThoughtPage> {
  late final TextEditingController _textController;
  late final TextEditingController _tagController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _tagController = TextEditingController();
    _loadUsedTags();
  }

  @override
  void dispose() {
    _textController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  /// 加载已使用的标签
  Future<void> _loadUsedTags() async {
    await widget.thoughtService.loadThoughts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: _buildSaveButton(),
    );
  }

  /// 构建主体内容
  Widget _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTextEditor(),
            const SizedBox(height: 16),
            _buildTagInput(),
          ],
        ),
      ),
    );
  }

  /// 构建保存按钮
  Widget _buildSaveButton() {
    return FloatingActionButton(
      onPressed: _saveNewThought,
      tooltip: AppConstants.saveTooltip,
      child: const Icon(Icons.save),
    );
  }

  /// 构建文本编辑器
  Widget _buildTextEditor() {
    return TextField(
      controller: _textController,
      maxLines: AppConstants.maxTextFieldLines,
      minLines: AppConstants.defaultTextFieldLines,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: AppConstants.thoughtHint,
      ),
    );
  }

  /// 构建标签输入区域
  Widget _buildTagInput() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTagTextField(),
            if (_hasUsedTags) ...[
              const SizedBox(height: 8),
              _buildTagSelector(),
            ],
          ],
        );
      },
    );
  }

  /// 构建标签文本字段
  Widget _buildTagTextField() {
    return TextField(
      controller: _tagController,
      decoration: const InputDecoration(
        labelText: AppConstants.tagLabel,
        hintText: AppConstants.tagHint,
        prefixIcon: Icon(Icons.tag),
      ),
    );
  }

  /// 构建标签选择器
  Widget _buildTagSelector() {
    return TagSelector(
      availableTags: widget.thoughtService.usedTags,
      onTagSelected: _onTagSelected,
    );
  }

  /// 检查是否有已使用的标签
  bool get _hasUsedTags => widget.thoughtService.usedTags.isNotEmpty;

  /// 标签选择回调
  void _onTagSelected(String tag) {
    _tagController.text = tag;
  }

  /// 保存新想法
  Future<void> _saveNewThought() async {
    final content = _textController.text.trim();
    
    if (!Utils.isNotEmpty(content)) return;

    final thought = await widget.thoughtService.addThoughtAndSave(
      content: content,
      tag: _tagController.text,
    );
    
    if (thought != null) {
      _clearInputs();
      _showSuccessMessage(thought.tag);
      widget.onThoughtAdded?.call();
    } else {
      _showErrorMessage();
    }
  }

  /// 清空输入框
  void _clearInputs() {
    setState(() {
      _textController.clear();
      _tagController.clear();
    });
  }

  /// 显示成功消息
  void _showSuccessMessage(String tag) {
    _showSnackBar('${AppConstants.thoughtSaved}"$tag"标签！');
  }

  /// 显示错误消息
  void _showErrorMessage() {
    _showSnackBar(AppConstants.dataSaveFailed);
  }

  /// 显示提示消息
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: AppConstants.snackBarDuration,
      ),
    );
  }
}
