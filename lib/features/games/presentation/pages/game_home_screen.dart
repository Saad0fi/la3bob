import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';

class GameCard extends StatelessWidget {
  final String? route;
  final String title;
  final String imagePath;
  final Color backgroundColor;
  final bool isPhysical;

  const GameCard({
    super.key,
    this.route,
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
    this.isPhysical = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route!),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.dp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 10.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.videogame_asset, size: 40.dp, color: Colors.grey),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.dp,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
              "عالم لعبوب ",
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
                    color: Colors.white.withOpacity(
                      0.2,
                    ), // خلفية خفيفة للتاب بار نفسه
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
              SizedBox(height: 15.w),

              const Expanded(
                child: TabBarView(
                  children: [_EducationalGamesTab(), _PhysicalGamesTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EducationalGamesTab extends StatelessWidget {
  const _EducationalGamesTab();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> eduGames = [
      {
        'title': 'لعبة الألوان',
        'route': '/tabs/games/colors',
        'image': 'assets/images/color.png',
        'color': const Color(0xFFF1F8E9), // أخضر فاتح
      },
      {
        'title': 'لعبة الأرقام',
        'route': '/tabs/games/numbers',
        'image': 'assets/images/numbers.png',
        'color': const Color(0xFFF7F1FF), // بنفسجي فاتح
      },
      {
        'title': 'لعبة الحروف',
        'route': '/tabs/games/letters',
        'image': 'assets/images/letters.png',
        'color': const Color(0xFFFFF3E0), // بيج فاتح
      },
      {
        'title': 'لعبة التطابق',
        'route': '/tabs/games/matching',
        'image': 'assets/images/matching.png',
        'color': const Color(0xFFE1F5FE), // أزرق فاتح
      },
    ];

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
        childAspectRatio: 0.9,
      ),
      itemCount: eduGames.length,
      itemBuilder: (context, index) {
        final game = eduGames[index];
        return GameCard(
          title: game['title'],
          route: game['route'],
          imagePath: game['image'],
          backgroundColor: game['color'],
        );
      },
    );
  }
}

class _PhysicalGamesTab extends StatelessWidget {
  const _PhysicalGamesTab();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> phyGames = [
      {
        'title': ' القرفصاء',
        'isPhysical': true,
        'image': 'assets/images/gamer.png',
        'color': const Color(0xFFF1F8E9),
      },
      {
        'title': ' القفز',
        'route': '/tabs/games/jump',
        'image': 'assets/images/long-jump.png',
        'color': const Color(0xFFF7F1FF),
      },
      {
        'title': 'أوامر القائد',
        'route': '/tabs/games/simon_says',
        'image': 'assets/images/command.png',
        'color': const Color(0xFFFFF3E0),
      },
      {
        'title': ' حركة حركة ستوب',
        'route': '/tabs/games/freeze',
        'image': 'assets/images/running.png',
        'color': const Color(0xFFE1F5FE),
      },
    ];
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
        childAspectRatio: 0.9,
      ),
      itemCount: phyGames.length,
      itemBuilder: (context, index) {
        final game = phyGames[index];
        return GameCard(
          title: game['title'],
          route: game['route'],
          imagePath: game['image'],
          backgroundColor: game['color'],
          isPhysical: game['isPhysical'] ?? false,
        );
      },
    );
  }
}
