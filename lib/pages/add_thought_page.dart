import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/thought_service.dart';
import '../utils/utils.dart';
import '../widgets/common_widgets.dart';

class AddThoughtPage extends StatefulWidget {
  final ThoughtService thoughtService;
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
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // No need to load all thoughts here, just the used tags.
    widget.thoughtService.loadThoughts(); 
  }

  @override
  void dispose() {
    _textController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增想法'),
      ),
      body: Padding(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNewThought,
        tooltip: AppConstants.saveTooltip,
        child: const Icon(Icons.save),
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
      autofocus: true,
    );
  }

  Widget _buildTagInput() {
    // Using a StatefulWidget to manage the state of the tag selector visibility
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
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
            if (widget.thoughtService.usedTags.isNotEmpty) ...[
              const SizedBox(height: 8),
              TagSelector(
                availableTags: widget.thoughtService.usedTags,
                onTagSelected: (tag) {
                  _tagController.text = tag;
                },
              ),
            ],
          ],
        );
      }
    );
  }

  Future<void> _saveNewThought() async {
    final content = _textController.text.trim();
    
    if (Utils.isNotEmpty(content)) {
      final thought = await widget.thoughtService.addThoughtAndSave(
        content: content,
        tag: _tagController.text,
      );
      
      if (thought != null) {
        setState(() {
          _textController.clear();
          _tagController.clear();
        });
        
        _showSnackBar('${AppConstants.thoughtSaved}"${thought.tag}"标签！');
        // Notify parent that a thought was added
        widget.onThoughtAdded?.call();
      } else {
        _showSnackBar(AppConstants.dataSaveFailed);
      }
    }
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
