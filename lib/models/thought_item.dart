/// 想法数据模型
class ThoughtItem {
  /// 唯一标识符
  final String id;
  
  /// 想法内容
  final String content;
  
  /// 标签
  final String tag;
  
  /// 创建时间
  final DateTime createdAt;
  
  /// 可选标题
  final String? title;
  
  /// 可选作者或出处
  final String? author;

  const ThoughtItem({
    required this.id,
    required this.content,
    required this.tag,
    required this.createdAt,
    this.title,
    this.author,
  });

  /// 复制并修改想法
  ThoughtItem copyWith({
    String? id,
    String? content,
    String? tag,
    DateTime? createdAt,
    String? title,
    String? author,
  }) {
    return ThoughtItem(
      id: id ?? this.id,
      content: content ?? this.content,
      tag: tag ?? this.tag,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      author: author ?? this.author,
    );
  }

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'tag': tag,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'title': title,
      'author': author,
    };
  }

  /// 从Map创建
  factory ThoughtItem.fromMap(Map<String, dynamic> map) {
    return ThoughtItem(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      tag: map['tag'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      title: map['title'],
      author: map['author'],
    );
  }

  /// 转换为JSON字符串
  String toJson() {
    final map = toMap();
    return '{"id":"${map['id']}","content":"${(map['content'] as String).replaceAll('"', '\\"')}","tag":"${map['tag']}","createdAt":${map['createdAt']},"title":"${map['title'] ?? ''}","author":"${map['author'] ?? ''}"}';
  }

  /// 从JSON字符串创建
  factory ThoughtItem.fromJson(String jsonString) {
    final map = <String, dynamic>{};
    // 简单的JSON解析
    final cleanJson = jsonString.substring(1, jsonString.length - 1);
    final pairs = cleanJson.split('","');
    
    for (final pair in pairs) {
      final keyValue = pair.split('":"');
      if (keyValue.length == 2) {
        String key = keyValue[0].replaceAll('"', '');
        String value = keyValue[1].replaceAll('"', '');
        
        if (key == 'createdAt') {
          map[key] = int.tryParse(value) ?? 0;
        } else {
          final cleanValue = value.replaceAll('\\"', '"');
          if (key == 'title' && cleanValue.isEmpty) {
            map[key] = null;
          } else if (key == 'author' && cleanValue.isEmpty) {
            map[key] = null;
          } else {
            map[key] = cleanValue;
          }
        }
      }
    }
    
    return ThoughtItem.fromMap(map);
  }
}
