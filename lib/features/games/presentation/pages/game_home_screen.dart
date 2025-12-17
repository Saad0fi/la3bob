import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';
import 'package:la3bob/features/games/presentation/widgets/tab_bar.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';

class GameHomeScreen extends StatelessWidget {
  const GameHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Center(
            child: Text(
              "عالم لعبوب",
              style: TextStyle(
                fontSize: 25.dp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(2.w),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.w),
                onLongPress: () {
                  context.read<PorfileBloc>().add(const LoadChildren());
                  context.push('/profile');
                },
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(2.w),
                  child: const Icon(color: Colors.white, Icons.settings),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.backgroundStart,
                AppColors.backgroundMiddle,
                AppColors.backgroundEnd,
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(15.dp),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(15.dp),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: TextStyle(
                      fontSize: 14.dp,
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: const [
                      Tab(text: 'ألعاب تعليمية'),
                      Tab(text: 'ألعاب حركية'),
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [EducationalGamesTab(), PhysicalGamesTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
