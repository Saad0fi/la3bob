import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/features/games/presentation/pages/wave_page.dart';
import 'package:la3bob/features/games/presentation/pages/squat_page.dart';

class GameHomeScreen extends StatelessWidget {
  const GameHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("ألعاب")),
          actions: [
            Padding(
              padding: EdgeInsets.all(2.w),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.w),
                onLongPress: () {
                  context.push('/profile');
                },
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(2.w),
                  child: const Icon(Icons.settings),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ألعاب تعليمية', icon: Icon(Icons.school)),
              Tab(text: 'ألعاب حركية', icon: Icon(Icons.sports)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // تبويب الألعاب التعليمية
            _EducationalGamesTab(),
            // تبويب الألعاب الحركية
            _PhysicalGamesTab(),
          ],
        ),
      ),
    );
  }
}

class _EducationalGamesTab extends StatelessWidget {
  const _EducationalGamesTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'اختر لعبة',
                style: TextStyle(
                  fontSize: 18.dp,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 6.h),
              // لعبة الحروف
              GestureDetector(
                onTap: () {
                  context.push('/tabs/games/letters');
                },
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.3),
                        blurRadius: 5.w,
                        spreadRadius: 1.w,
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
                              'لعبة الحروف',
                              style: TextStyle(
                                fontSize: 14.dp,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'تعلم الحروف العربية مع الكلمات',
                              style: TextStyle(
                                fontSize: 10.dp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.purple,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              // لعبة الأرقام
              GestureDetector(
                onTap: () {
                  context.push('/tabs/games/numbers');
                },
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(6.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 5.w,
                        spreadRadius: 1.w,
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
                              'لعبة الأرقام',
                              style: TextStyle(
                                fontSize: 14.dp,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'تعلم الأرقام والعد',
                              style: TextStyle(
                                fontSize: 10.dp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              // لعبة الألوان
              GestureDetector(
                onTap: () {
                  context.push('/tabs/games/colors');
                },
                child: Container(
                  padding: .all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(6.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.3),
                        blurRadius: 5.w,
                        spreadRadius: 1.w,
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
                              'لعبة الألوان',
                              style: TextStyle(
                                fontSize: 14.dp,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'تعلم أسماء الألوان العربية',
                              style: TextStyle(
                                fontSize: 10.dp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.orange,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhysicalGamesTab extends StatelessWidget {
  const _PhysicalGamesTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: .all(5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'اختر لعبة',
                style: TextStyle(
                  fontSize: 18.dp,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              SizedBox(height: 6.h),
              // لعبة الموجة (Wave)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WaveGamePage()),
                  );
                },
                child: Container(
                  padding: .all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(6.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.3),
                        blurRadius: 5.w,
                        spreadRadius: 1.w,
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
                              'لعبة الموجة',
                              style: TextStyle(
                                fontSize: 14.dp,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'لوّح بيدك لتجمع النقاط',
                              style: TextStyle(
                                fontSize: 10.dp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.orange,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              // لعبة القرفصاء (Squat)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SquatGamePage()),
                  );
                },
                child: Container(
                  padding: .all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(6.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        blurRadius: 5.w,
                        spreadRadius: 1.w,
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
                              'لعبة القرفصاء',
                              style: TextStyle(
                                fontSize: 14.dp,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'تمرين القرفصاء مع الكاميرا',
                              style: TextStyle(
                                fontSize: 10.dp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.green,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
