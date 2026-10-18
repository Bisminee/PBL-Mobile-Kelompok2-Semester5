import 'package:flutter/material.dart';

import '../../config/app_assets.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../common/app_button.dart';

/// Navigasi samping untuk layar lebar (laptop / tablet lanskap).
/// Pengganti [FloatingNavBar] yang dipakai di HP.
class SideNavRail extends StatelessWidget {
  const SideNavRail({
    super.key,
    required this.index,
    required this.onHome,
    required this.onWardrobe,
    required this.onCamera,
    required this.onProfile,
  });

  /// 0 = Home, 1 = Lemari
  final int index;
  final VoidCallback onHome;
  final VoidCallback onWardrobe;
  final VoidCallback onCamera;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 232,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(AppAssets.logo, width: 36, height: 36),
                  ),
                  const SizedBox(width: 10),
                  Text('Sera-Z', style: AppTextStyles.h3),
                ]),
              ),
              const SizedBox(height: 32),
              _RailItem(
                icon: Icons.home_filled,
                label: 'Home',
                active: index == 0,
                onTap: onHome,
              ),
              const SizedBox(height: 4),
              _RailItem(
                icon: Icons.checkroom_outlined,
                label: 'Lemari',
                active: index == 1,
                onTap: onWardrobe,
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Foto Pakaian',
                icon: Icons.photo_camera_outlined,
                height: 48,
                onPressed: onCamera,
              ),
              const Spacer(),
              _RailItem(
                icon: Icons.person_outline,
                label: 'Profil',
                active: false,
                onTap: onProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.textPrimary : AppColors.textSecondary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: active ? AppColors.secondaryBg : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTextStyles.title.copyWith(
              fontSize: 14,
              color: color,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ]),
      ),
    );
  }
}
