import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:go_router/go_router.dart';



import 'package:la3bob/features/games/presentation/pages/squat_page.dart';

import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';



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

                  context.read<PorfileBloc>().add(const LoadChildren());



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

              GestureDetector(

                onTap: () {

                  context.push('/tabs/games/letters');

                },

                child: Container(

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.purple.withValues(alpha: .3),

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

                            const Text(

                              'لعبة الحروف',

                              style: TextStyle(

                                fontSize: 24,

                                fontWeight: FontWeight.bold,

                                color: Colors.purple,

                              ),

                            ),

                            const SizedBox(height: 8),

                            Text(

                              'تعلم الحروف العربية مع الكلمات',

                              style: TextStyle(

                                fontSize: 16,

                                color: Colors.grey.shade700,

                              ),

                            ),

                          ],

                        ),

                      ),

                      const Icon(Icons.arrow_forward_ios, color: Colors.purple),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 30),

              // لعبة الأرقام

              GestureDetector(

                onTap: () {

                  context.push('/tabs/games/numbers');

                },

                child: Container(

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.blue.withValues(alpha: .3),

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

                            const Text(

                              'لعبة الأرقام',

                              style: TextStyle(

                                fontSize: 24,

                                fontWeight: FontWeight.bold,

                                color: Colors.blue,

                              ),

                            ),

                            const SizedBox(height: 8),

                            Text(

                              'تعلم الأرقام والعد',

                              style: TextStyle(

                                fontSize: 16,

                                color: Colors.grey.shade700,

                              ),

                            ),

                          ],

                        ),

                      ),

                      const Icon(Icons.arrow_forward_ios, color: Colors.blue),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 30),

              // لعبة الألوان

              GestureDetector(

                onTap: () {

                  context.push('/tabs/games/colors');

                },

                child: Container(

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.orange.withValues(alpha: .3),

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

                            const Text(

                              'لعبة الألوان',

                              style: TextStyle(

                                fontSize: 24,

                                fontWeight: FontWeight.bold,

                                color: Colors.orange,

                              ),

                            ),

                            const SizedBox(height: 8),

                            Text(

                              'تعلم أسماء الألوان العربية',

                              style: TextStyle(

                                fontSize: 16,

                                color: Colors.grey.shade700,

                              ),

                            ),

                          ],

                        ),

                      ),

                      const Icon(Icons.arrow_forward_ios, color: Colors.orange),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 30),

              // لعبة التطابق

              GestureDetector(

                onTap: () {

                  context.push('/tabs/games/matching');

                },

                child: Container(

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.teal.withValues(alpha: .3),

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

                            const Text(

                              'لعبة التطابق',

                              style: TextStyle(

                                fontSize: 24,

                                fontWeight: FontWeight.bold,

                                color: Colors.teal,

                              ),

                            ),

                            const SizedBox(height: 8),

                            Text(

                              'اختر الشكلين المتطابقين',

                              style: TextStyle(

                                fontSize: 16,

                                color: Colors.grey.shade700,

                              ),

                            ),

                          ],

                        ),

                      ),

                      const Icon(Icons.arrow_forward_ios, color: Colors.teal),

                    ],

                  ),

                ),

              ),

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

              // لعبة القرفصاء (Squat)

              GestureDetector(

                onTap: () {

                  Navigator.of(context).push(

                    MaterialPageRoute(builder: (_) => const SquatGamePage()),

                  );

                },

                child: Container(

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.green.withValues(alpha: .3),

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

                            const Text(

                              'لعبة القرفصاء',

                              style: TextStyle(

                                fontSize: 24,

                                fontWeight: FontWeight.bold,

                                color: Colors.green,

                              ),

                            ),

                            const SizedBox(height: 8),

                            Text(

                              'تمرين القرفصاء مع الكاميرا',

                              style: TextStyle(

                                fontSize: 16,

                                color: Colors.grey.shade700,

                              ),

                            ),

                          ],

                        ),

                      ),

                      const Icon(Icons.arrow_forward_ios, color: Colors.green),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 30),

              // لعبة القفز (Jump)

              GestureDetector(

                onTap: () {

                  context.push('/tabs/games/jump');

                },

                child: Container(

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.blue.withValues(alpha: .3),

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

                            const Text(

                              'لعبة القفز',

                              style: TextStyle(

                                fontSize: 24,

                                fontWeight: FontWeight.bold,

                                color: Colors.blue,

                              ),

                            ),

                            const SizedBox(height: 8),

                            Text(

                              'اقفز لتتجاوز العقبات!',

                              style: TextStyle(

                                fontSize: 16,

                                color: Colors.grey.shade700,

                              ),

                            ),

                          ],

                        ),

                      ),

                      const Icon(Icons.arrow_forward_ios, color: Colors.blue),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 30),

              // لعبة أوامر القائد (Simon Says)

              GestureDetector(

                onTap: () {

                  context.push('/tabs/games/simon_says');

                },

                child: Container(

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.purple.withValues(alpha: .3),

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

                            const Text(

                              'أوامر القائد',

                              style: TextStyle(

                                fontSize: 24,

                                fontWeight: FontWeight.bold,

                                color: Colors.purple,

                              ),

                            ),

                            const SizedBox(height: 8),

                            Text(

                              'نفذ الأوامر بسرعة!',

                              style: TextStyle(

                                fontSize: 16,

                                color: Colors.grey.shade700,

                              ),

                            ),

                          ],

                        ),

                      ),

                      const Icon(Icons.arrow_forward_ios, color: Colors.purple),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 30),

              // لعبة التجمد (Freeze)

              GestureDetector(

                onTap: () {

                  context.push('/tabs/games/freeze');

                },

                child: Container(

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.red.withValues(alpha: .3),

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

                            const Text(

                              'لعبة التجمد',

                              style: TextStyle(

                                fontSize: 24,

                                fontWeight: FontWeight.bold,

                                color: Colors.red,

                              ),

                            ),

                            const SizedBox(height: 8),

                            Text(

                              'تحرك ثم تجمد!',

                              style: TextStyle(

                                fontSize: 16,

                                color: Colors.grey.shade700,

                              ),

                            ),

                          ],

                        ),

                      ),

                      const Icon(Icons.arrow_forward_ios, color: Colors.red),

                    ],

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}
