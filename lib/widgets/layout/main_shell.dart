import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_routes.dart';
import '../common/responsive.dart';
import 'floating_nav_bar.dart';
import 'side_nav_rail.dart';

/// Shell Home | Kamera | Lemari.
/// HP / tablet potret: bottom nav melayang. Laptop / tablet lanskap: navigasi samping.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (context.isExpanded) {
      return Scaffold(
        body: Row(
          children: [
            SideNavRail(
              index: navigationShell.currentIndex,
              onHome: () => _goBranch(0),
              onWardrobe: () => _goBranch(1),
              onCamera: () => context.push(AppRoutes.camera),
              onProfile: () => context.push(AppRoutes.profile),
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: FloatingNavBar(
        index: navigationShell.currentIndex,
        onHome: () => _goBranch(0),
        onWardrobe: () => _goBranch(1),
        onCamera: () => context.push(AppRoutes.camera),
      ),
    );
  }
}
