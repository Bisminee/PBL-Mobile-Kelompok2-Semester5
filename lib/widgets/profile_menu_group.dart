import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class ProfileSectionLabel extends StatelessWidget {
  const ProfileSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(text, style: AppTextStyles.mono(10)),
        ),
      );
}

class ProfileMenuItem {
  ProfileMenuItem({
    required this.icon,
    required this.title,
    this.value,
    this.badge,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? value;
  final String? badge;
  final Widget? trailing;
  final VoidCallback? onTap;
}

/// Kartu bergaris berisi daftar menu dengan pemisah antar item.
class ProfileMenuGroup extends StatelessWidget {
  const ProfileMenuGroup({super.key, required this.items});
  final List<ProfileMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _Row(item: items[i]),
            if (i != items.length - 1)
              const Divider(height: 1, indent: 60, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.item});
  final ProfileMenuItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: AppColors.secondaryBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(item.icon, size: 17),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(item.title, style: AppTextStyles.body.copyWith(fontSize: 15))),
          if (item.badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(item.badge!, style: AppTextStyles.mono(9)),
            ),
          if (item.value != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(item.value!, style: AppTextStyles.label.copyWith(fontSize: 13)),
            ),
          item.trailing ??
              const Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
        ]),
      ),
    );
  }
}
