import 'package:flutter_test/flutter_test.dart';
import 'package:pencil/models/thought_item.dart';
import 'package:pencil/utils/form_manager.dart';

void main() {
  group('ThoughtFormManager', () {
    test('创建空表单管理器', () {
      final formManager = ThoughtFormManager();

      expect(formManager.titleController.text, '');
      expect(formManager.contentController.text, '');
      expect(formManager.authorController.text, '');
      expect(formManager.tagController.text, '');
    });

    test('从想法创建表单管理器', () {
      final thought = ThoughtItem(
        id: 'test-id',
        content: '测试内容',
        tag: '测试标签',
        createdAt: DateTime.now(),
        title: '测试标题',
        author: '测试作者',
      );

      final formManager = ThoughtFormManager.fromThought(thought);

      expect(formManager.titleController.text, '测试标题');
      expect(formManager.contentController.text, '测试内容');
      expect(formManager.authorController.text, '测试作者');
      expect(formManager.tagController.text, '测试标签');
    });

    test('验证空内容', () {
      final formManager = ThoughtFormManager();
      
      final result = formManager.validate();
      
      expect(result.isValid, false);
      expect(result.errorMessage, '想法内容不能为空');
    });

    test('验证有效内容', () {
      final formManager = ThoughtFormManager();
      formManager.contentController.text = '有效的想法内容';
      
      final result = formManager.validate();
      
      expect(result.isValid, true);
      expect(result.errorMessage, null);
    });

    test('获取处理后的标题', () {
      final formManager = ThoughtFormManager();
      
      // 测试空字符串
      formManager.titleController.text = '';
      expect(formManager.title, null);
      
      // 测试只有空格
      formManager.titleController.text = '   ';
      expect(formManager.title, null);
      
      // 测试有效标题
      formManager.titleController.text = '  有效标题  ';
      expect(formManager.title, '有效标题');
    });

    test('获取处理后的作者', () {
      final formManager = ThoughtFormManager();
      
      // 测试空字符串
      formManager.authorController.text = '';
      expect(formManager.author, null);
      
      // 测试只有空格
      formManager.authorController.text = '   ';
      expect(formManager.author, null);
      
      // 测试有效作者
      formManager.authorController.text = '  有效作者  ';
      expect(formManager.author, '有效作者');
    });

    test('检测变化', () {
      final originalThought = ThoughtItem(
        id: 'test-id',
        content: '原始内容',
        tag: '原始标签',
        createdAt: DateTime.now(),
        title: '原始标题',
        author: '原始作者',
      );

      final formManager = ThoughtFormManager.fromThought(originalThought);
      
      // 初始状态应该没有变化
      expect(formManager.hasChanges(originalThought), false);
      
      // 修改内容后应该有变化
      formManager.contentController.text = '新内容';
      expect(formManager.hasChanges(originalThought), true);
    });

    test('更新想法', () {
      final originalThought = ThoughtItem(
        id: 'test-id',
        content: '原始内容',
        tag: '原始标签',
        createdAt: DateTime.now(),
      );

      final formManager = ThoughtFormManager();
      formManager.contentController.text = '新内容';
      formManager.tagController.text = '新标签';
      formManager.titleController.text = '新标题';
      formManager.authorController.text = '新作者';

      final updatedThought = formManager.updateThought(originalThought);

      expect(updatedThought.content, '新内容');
      expect(updatedThought.tag, '新标签');
      expect(updatedThought.title, '新标题');
      expect(updatedThought.author, '新作者');
      expect(updatedThought.id, originalThought.id);
      expect(updatedThought.createdAt, originalThought.createdAt);
    });

    test('清空所有输入', () {
      final formManager = ThoughtFormManager();
      formManager.titleController.text = '标题';
      formManager.contentController.text = '内容';
      formManager.authorController.text = '作者';
      formManager.tagController.text = '标签';

      formManager.clearAll();

      expect(formManager.titleController.text, '');
      expect(formManager.contentController.text, '');
      expect(formManager.authorController.text, '');
      expect(formManager.tagController.text, '');
    });
  });
}
