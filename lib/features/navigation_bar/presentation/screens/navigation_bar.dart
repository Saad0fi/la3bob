import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            context.go('/tabs/videos');
          } else {
            context.go('/tabs/games');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam_sharp),
            label: "فيديوهات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad_sharp),
            label: "ألعاب",
          ),
        ],
      ),
    );
  }
}
