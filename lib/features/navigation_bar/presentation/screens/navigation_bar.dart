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
            child: Container(
              color: Colors.white,
              height: 85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    index: 0,
                    currentIndex: currentIndex,
                    icon: Icons.videocam_outlined,
                    activeIcon: Icons.videocam_rounded,
                    label: "فيديوهات",
                    onTap: () => context.go('/tabs/videos'),
                  ),
                  _buildNavItem(
                    context,
                    index: 1,
                    currentIndex: currentIndex,
                    icon: Icons.sports_esports_outlined,
                    activeIcon: Icons.sports_esports_rounded,
                    label: "ألعاب",
                    onTap: () => context.go('/tabs/games'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
          child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSelected ? 13 : 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
