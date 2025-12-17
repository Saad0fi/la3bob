import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';

class NavigationBarScreen extends StatelessWidget {
  final Widget child;

  const NavigationBarScreen({super.key, required this.child});

  int _currentIndexForLocation(String location) {
    if (location.startsWith('/tabs/games')) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).fullPath ?? '';
    final currentIndex = _currentIndexForLocation(location);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.7),
              width: 1.4,
            ),
            color: Colors.transparent,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              showUnselectedLabels: true,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
              onTap: (index) {
                if (index == 0) {
                  context.go('/tabs/videos');
                } else {
                  context.go('/tabs/games');
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.videocam_outlined),
                  activeIcon: Icon(Icons.videocam_rounded),
                  label: "فيديوهات",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_esports_outlined),
                  activeIcon: Icon(Icons.sports_esports_rounded),
                  label: "ألعاب",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
