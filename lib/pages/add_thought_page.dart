import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/thought_service.dart';
import '../services/notification_service.dart';
import '../utils/form_manager.dart';
import '../widgets/common_widgets.dart';
import '../widgets/input_widgets.dart';

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
  late final ThoughtFormManager _formManager;

  @override
  void initState() {
    super.initState();
    _formManager = ThoughtFormManager();
    _loadUsedTags();
  }

  @override
  void dispose() {
    _formManager.dispose();
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
            TitleInputField(controller: _formManager.titleController),
            const SizedBox(height: 16),
            ContentInputField(controller: _formManager.contentController),
            const SizedBox(height: 16),
            AuthorInputField(controller: _formManager.authorController),
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

  /// 构建标签输入区域
  Widget _buildTagInput() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TagInputField(controller: _formManager.tagController),
            if (_hasUsedTags) ...[
              const SizedBox(height: 8),
              _buildTagSelector(),
            ],
          ],
        );
      },
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
    _formManager.tagController.text = tag;
  }

  /// 保存新想法
  Future<void> _saveNewThought() async {
    final validationResult = _formManager.validate();
    
    if (!validationResult.isValid) {
      if (validationResult.errorMessage != null) {
        NotificationService.showError(context, validationResult.errorMessage!);
      }
      return;
    }

    final thought = await _formManager.createThought(widget.thoughtService);
    
    if (!mounted) return;
    
    if (thought != null) {
      _clearInputs();
      NotificationService.showThoughtSaved(context, thought.tag);
      widget.onThoughtAdded?.call();
    } else {
      NotificationService.showDataSaveFailed(context);
    }
  }

  /// 清空输入框
  void _clearInputs() {
    setState(() {
      _formManager.clearAll();
    });
  }
}
