import 'package:flutter/material.dart';

import '../config/app_sizes.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.helper,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final String? helper;
  final TextInputType? keyboardType;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _focus = FocusNode();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 56,
          decoration: BoxDecoration(
            color: focused ? Colors.white : AppColors.secondaryBg,
            borderRadius: BorderRadius.circular(AppSizes.radiusField),
            border: Border.all(
              color: focused ? AppColors.textPrimary : Colors.transparent,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          child: TextField(
            controller: widget.controller,
            focusNode: _focus,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword && _obscure,
            style: AppTextStyles.body.copyWith(fontSize: 15),
            decoration: InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              hintText: widget.hint,
              hintStyle: AppTextStyles.body
                  .copyWith(fontSize: 15, color: AppColors.textSecondary.withValues(alpha: 0.7)),
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
          ),
        ),
        if (widget.helper != null) ...[
          const SizedBox(height: 8),
          Text(widget.helper!, style: AppTextStyles.label.copyWith(fontSize: 11)),
        ],
      ],
    );
  }
}
