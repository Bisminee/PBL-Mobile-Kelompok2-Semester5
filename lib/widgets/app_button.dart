import 'package:flutter/material.dart';

import '../config/app_sizes.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

enum AppButtonStyle { filled, outlined, white }

/// Tombol pill: hitam (filled), outline, atau putih (untuk background gelap).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.filled,
    this.icon,
    this.trailingIcon,
    this.height = AppSizes.buttonHeight,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final IconData? icon;
  final IconData? trailingIcon;
  final double height;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final BorderSide side;
    switch (style) {
      case AppButtonStyle.filled:
        bg = AppColors.accent;
        fg = Colors.white;
        side = BorderSide.none;
        break;
      case AppButtonStyle.outlined:
        bg = Colors.transparent;
        fg = AppColors.textPrimary;
        side = const BorderSide(color: AppColors.textPrimary, width: 1);
        break;
      case AppButtonStyle.white:
        bg = Colors.white;
        fg = AppColors.textPrimary;
        side = BorderSide.none;
        break;
    }

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 18, color: fg), const SizedBox(width: 8)],
        Text(label, style: AppTextStyles.button.copyWith(color: fg)),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 18, color: fg),
        ],
      ],
    );

    return SizedBox(
      height: height,
      width: expand ? double.infinity : null,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: bg,
          shape: StadiumBorder(side: side),
          padding: const EdgeInsets.symmetric(horizontal: 28),
        ),
        child: child,
      ),
    );
  }
}
