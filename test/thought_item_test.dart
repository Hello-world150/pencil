import 'package:flutter_test/flutter_test.dart';
import 'package:pencil/models/thought_item.dart';

void main() {
  group('ThoughtItem', () {
    test('创建带有标题和作者的想法', () {
      final thought = ThoughtItem(
        id: 'test-id',
        content: '这是一个测试想法',
        tag: '测试',
        createdAt: DateTime(2023, 1, 1),
        title: '测试标题',
        author: '测试作者',
      );

      expect(thought.id, 'test-id');
      expect(thought.content, '这是一个测试想法');
      expect(thought.tag, '测试');
      expect(thought.title, '测试标题');
      expect(thought.author, '测试作者');
      expect(thought.createdAt, DateTime(2023, 1, 1));
    });

    test('创建不带标题和作者的想法', () {
      final thought = ThoughtItem(
        id: 'test-id',
        content: '这是一个测试想法',
        tag: '测试',
        createdAt: DateTime(2023, 1, 1),
      );

      expect(thought.title, isNull);
      expect(thought.author, isNull);
    });

    test('转换为Map并包含新字段', () {
      final createdAt = DateTime(2023, 1, 1);
      final thought = ThoughtItem(
        id: 'test-id',
        content: '这是一个测试想法',
        tag: '测试',
        createdAt: createdAt,
        title: '测试标题',
        author: '测试作者',
      );

      final map = thought.toMap();

      expect(map['id'], 'test-id');
      expect(map['content'], '这是一个测试想法');
      expect(map['tag'], '测试');
      expect(map['title'], '测试标题');
      expect(map['author'], '测试作者');
      expect(map['createdAt'], createdAt.millisecondsSinceEpoch);
    });

    test('从Map创建包含新字段的想法', () {
      final createdAt = DateTime(2023, 1, 1);
      final map = {
        'id': 'test-id',
        'content': '这是一个测试想法',
        'tag': '测试',
        'createdAt': createdAt.millisecondsSinceEpoch,
        'title': '测试标题',
        'author': '测试作者',
      };

      final thought = ThoughtItem.fromMap(map);

      expect(thought.id, 'test-id');
      expect(thought.content, '这是一个测试想法');
      expect(thought.tag, '测试');
      expect(thought.title, '测试标题');
      expect(thought.author, '测试作者');
      expect(thought.createdAt, createdAt);
    });

    test('从Map创建不包含新字段的想法（向后兼容）', () {
      final createdAt = DateTime(2023, 1, 1);
      final map = {
        'id': 'test-id',
        'content': '这是一个测试想法',
        'tag': '测试',
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

      final thought = ThoughtItem.fromMap(map);

      expect(thought.id, 'test-id');
      expect(thought.content, '这是一个测试想法');
      expect(thought.tag, '测试');
      expect(thought.title, isNull);
      expect(thought.author, isNull);
      expect(thought.createdAt, createdAt);
    });

    test('copyWith 包含新字段', () {
      final originalThought = ThoughtItem(
        id: 'test-id',
        content: '原始内容',
        tag: '原始标签',
        createdAt: DateTime(2023, 1, 1),
      );

      final updatedThought = originalThought.copyWith(
        title: '新标题',
        author: '新作者',
      );

      expect(updatedThought.id, 'test-id');
      expect(updatedThought.content, '原始内容');
      expect(updatedThought.tag, '原始标签');
      expect(updatedThought.title, '新标题');
      expect(updatedThought.author, '新作者');
      expect(updatedThought.createdAt, DateTime(2023, 1, 1));
    });
  });
}
