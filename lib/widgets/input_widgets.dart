import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// 通用输入框组件
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.maxLines,
    this.minLines,
    this.autofocus = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      autofocus: autofocus,
      keyboardType: keyboardType,
      onChanged: onChanged != null ? (_) => onChanged!() : null,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

/// 标题输入框组件
class TitleInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const TitleInputField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: '标题（可选）',
      hintText: '为你的想法添加一个标题...',
      prefixIcon: Icons.title,
      onChanged: onChanged,
    );
  }
}

/// 作者输入框组件
class AuthorInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const AuthorInputField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: '作者/出处（可选）',
      hintText: '记录想法的来源或作者...',
      prefixIcon: Icons.person_outline,
      onChanged: onChanged,
    );
  }
}

/// 内容输入框组件
class ContentInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const ContentInputField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: AppConstants.thoughtHint,
      maxLines: AppConstants.maxTextFieldLines,
      minLines: AppConstants.defaultTextFieldLines,
      autofocus: true,
      onChanged: onChanged,
    );
  }
}

/// 标签输入框组件
class TagInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const TagInputField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: AppConstants.tagLabel,
      hintText: AppConstants.tagHint,
      prefixIcon: Icons.tag,
      onChanged: onChanged,
    );
  }
}
