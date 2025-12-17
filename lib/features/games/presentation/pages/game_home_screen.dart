import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';

class _GameCard extends StatelessWidget {
  final String route;
  final String title;
  final String subtitle;
  final Color color;

  const _GameCard({
    required this.route,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color),
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
              TabBar(
                indicatorColor: AppColors.accent,
                labelColor: AppColors.accent,
                unselectedLabelColor: AppColors.textPrimary,
                labelStyle: TextStyle(
                  fontSize: 12.dp,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(fontSize: 11.dp),
                tabs: const [
                  Tab(text: 'ألعاب تعليمية', icon: Icon(Icons.school)),
                  Tab(text: 'ألعاب حركية', icon: Icon(Icons.sports)),
                ],
              ),

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'اختر لعبة',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 50),

            // لعبة الحروف
            _GameCard(
              route: '/tabs/games/letters',
              title: 'لعبة الحروف',
              subtitle: 'تعلم الحروف العربية مع الكلمات',
              color: Colors.purple,
            ),

            const SizedBox(height: 30),

            // لعبة الأرقام
            _GameCard(
              route: '/tabs/games/numbers',
              title: 'لعبة الأرقام',
              subtitle: 'تعلم الأرقام والعد',
              color: Colors.blue,
            ),

            const SizedBox(height: 30),

            // لعبة الألوان
            _GameCard(
              route: '/tabs/games/colors',
              title: 'لعبة الألوان',
              subtitle: 'تعلم أسماء الألوان العربية',
              color: Colors.orange,
            ),

            const SizedBox(height: 30),

            // لعبة التطابق
            _GameCard(
              route: '/tabs/games/matching',
              title: 'لعبة التطابق',
              subtitle: 'اختر الشكلين المتطابقين',
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}

class _PhysicalGamesTab extends StatelessWidget {
  const _PhysicalGamesTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'اختر لعبة',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 50),

            const _GameCard(
              route: '/tabs/games/squat',
              title: 'لعبة القرفصاء',
              subtitle: 'تمرين القرفصاء مع الكاميرا',
              color: Colors.green,
            ),

            const SizedBox(height: 30),

            // لعبة القفز (Jump)
            const _GameCard(
              route: '/tabs/games/jump',
              title: 'لعبة القفز',
              subtitle: 'اقفز لتتجاوز العقبات!',
              color: Colors.blue,
            ),

            const SizedBox(height: 30),

            // لعبة أوامر القائد (Simon Says)
            const _GameCard(
              route: '/tabs/games/simon_says',
              title: 'أوامر القائد',
              subtitle: 'نفذ الأوامر بسرعة!',
              color: Colors.purple,
            ),

            const SizedBox(height: 30),

            // لعبة التجمد (Freeze)
            const _GameCard(
              route: '/tabs/games/freeze',
              title: 'لعبة التجمد',
              subtitle: 'تحرك ثم تجمد!',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
