import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/providers.dart';

import '../config/app_routes.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/app_button.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/profile_menu_group.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: CircleIconButton(
                      icon: Icons.chevron_left, onPressed: () => context.pop()),
                ),
              ),
              const SizedBox(height: 4),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    alignment: Alignment.center,
                    child: Text('F', style: AppTextStyles.h1),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                        color: AppColors.accent, shape: BoxShape.circle),
                    child: const Icon(Icons.photo_camera_outlined,
                        color: Colors.white, size: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Falaaa', style: AppTextStyles.h2),
              const SizedBox(height: 4),
              Text('Fala@email.com', style: AppTextStyles.bodySecondary),
              const SizedBox(height: 28),
              const ProfileSectionLabel('ACCOUNT'),
              ProfileMenuGroup(items: [
                ProfileMenuItem(icon: Icons.person_outline, title: 'Edit Profile'),
                ProfileMenuItem(icon: Icons.lock_outline, title: 'Change Password'),
                ProfileMenuItem(
                    icon: Icons.grid_view_rounded, title: 'Admin Panel', badge: 'ADMIN'),
              ]),
              const SizedBox(height: 22),
              const ProfileSectionLabel('PREFERENCES'),
              ProfileMenuGroup(items: [
                ProfileMenuItem(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  trailing: Switch(
                    value: _notif,
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.accent,
                    onChanged: (v) => setState(() => _notif = v),
                  ),
                ),
                ProfileMenuItem(
                    icon: Icons.contrast, title: 'Appearance', value: 'Terang'),
              ]),
              const SizedBox(height: 22),
              const ProfileSectionLabel('ABOUT'),
              ProfileMenuGroup(items: [
                ProfileMenuItem(icon: Icons.info_outline, title: 'About Sera-Z', value: 'v1.0'),
                ProfileMenuItem(icon: Icons.shield_outlined, title: 'Privacy Policy'),
                ProfileMenuItem(icon: Icons.description_outlined, title: 'Terms & Conditions'),
              ]),
              const SizedBox(height: 24),
              AppButton(
                label: 'Logout',
                icon: Icons.logout,
                style: AppButtonStyle.outlined,
                height: 52,
                onPressed: () {
                  ref.read(authProvider.notifier).signOut();
                  context.go(AppRoutes.login);
                },
              ),
              const SizedBox(height: 16),
              Text('SERA-Z · VERSI 1.0.0', style: AppTextStyles.mono(10)),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
