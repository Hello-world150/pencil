import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pencil/main.dart';

void main() {
  testWidgets('应用启动测试', (WidgetTester tester) async {
    // 构建应用并触发一个帧
    await tester.pumpWidget(const PencilApp());

    // 等待初始帧完成
    await tester.pump();

    // 验证标题是否正确显示
    expect(find.text('Pencil'), findsOneWidget);
    
    // 检查是否有加载指示器或文本输入框
    final hasLoader = find.byType(CircularProgressIndicator);
    final hasTextHint = find.text('在这里写下你的想法...');
    
    // 应该至少有一个存在（要么在加载，要么已经加载完成显示输入框）
    expect(hasLoader.evaluate().isNotEmpty || hasTextHint.evaluate().isNotEmpty, isTrue);
  });
}
