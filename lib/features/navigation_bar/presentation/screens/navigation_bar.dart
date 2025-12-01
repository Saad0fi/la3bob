import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la3bob/features/navigation_bar/presentation/bloc/navigation_bar_bloc.dart';

class NavigationBarScreen extends StatelessWidget {
  const NavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBarBloc(),
      child: BlocBuilder<NavigationBarBloc, NavigationBarState>(
        builder: (context, state) {
          final bloc = context.read<NavigationBarBloc>();
          return Scaffold(
            body: bloc.screens[bloc.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: bloc.currentIndex,
              onTap: (index) => bloc.add(NavigationBarTapEvent(index)),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.videocam_sharp),
                  label: "فيديوهات",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.games),
                  label: "ألعاب",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
