import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../services/auth_service.dart';
import '../../services/providers.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/profile/profile_menu_group.dart';

/// Profil dan pengaturan akun, termasuk logout.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final AuthService _authService = AuthService();
  bool _notif = true;
  bool _busy = false;

  Future<void> _signOut() async {
    setState(() => _busy = true);
    try {
      await _authService.signOut();
      ref.read(authProvider.notifier).signOut();
      ref.read(wardrobeProvider.notifier).clear();
      if (mounted) context.go(AppRoutes.login);
    } catch (error) {
      _showMessage('Gagal keluar. Coba lagi.');
      debugPrint('Logout gagal: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus akun?'),
        content: const Text(
          'Profil, lemari, dan riwayat akan dihapus permanen. '
          'Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Hapus',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    setState(() => _busy = true);

    try {
      await _authService.deleteAccount();
      ref.read(authProvider.notifier).signOut();
      ref.read(wardrobeProvider.notifier).clear();
      if (mounted) context.go(AppRoutes.login);
    } on AuthReauthRequiredException {
      _showMessage(
        'Sesi sudah lama. Silakan login ulang, lalu hapus akun dari halaman ini.',
      );
    } catch (error) {
      _showMessage('Gagal menghapus akun. Coba lagi.');
      debugPrint('Hapus akun gagal: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ContentWidth(
            maxWidth: 560,
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
                      activeThumbColor: Colors.white,
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
                  label: _busy ? 'Memproses...' : 'Logout',
                  icon: Icons.logout,
                  style: AppButtonStyle.outlined,
                  height: 52,
                  onPressed: _busy ? null : _signOut,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _busy ? null : _deleteAccount,
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: Text(
                    'Hapus Akun',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('SERA-Z · VERSI 1.0.0', style: AppTextStyles.mono(10)),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
