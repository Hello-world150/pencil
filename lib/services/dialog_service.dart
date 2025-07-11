import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// 确认对话框服务
class DialogService {
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = '确定',
    String cancelText = '取消',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  static Future<bool> showDiscardChangesDialog(BuildContext context) {
    return showConfirmDialog(
      context,
      title: '放弃更改？',
      content: '您有未保存的更改，确定要离开吗？',
      confirmText: '放弃',
      cancelText: AppConstants.cancelButton,
      isDestructive: true,
    );
  }
}
