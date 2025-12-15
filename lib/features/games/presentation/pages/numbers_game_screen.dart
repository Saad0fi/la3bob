import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/features/games/presentation/bloc/games_bloc.dart';
import 'package:la3bob/features/games/presentation/widgets/game_option_tile.dart';

class NumbersGameScreen extends StatelessWidget {
  const NumbersGameScreen({super.key});

  String _getArabicNumber(int number) {
    const arabicNumbers = [
      'صفر',
      'واحد',
      'اثنان',
      'ثلاثة',
      'أربعة',
      'خمسة',
      'ستة',
      'سبعة',
      'ثمانية',
      'تسعة',
      'عشرة',
      'أحد عشر',
      'اثنا عشر',
    ];
    return arabicNumbers[number];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GamesBloc()..add(const InitializeNumbersGame()),
      child: BlocListener<GamesBloc, GamesState>(
        listener: (context, state) {
          if (state is GameLoaded &&
              state.gameType == GameType.numbers &&
              state.showResult) {
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                context.read<GamesBloc>().add(const MoveToNextQuestion());
              }
            });
          } else if (state is GameCompleted &&
              state.gameType == GameType.numbers) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                title: const Text('🎉 ممتاز! 🎉'),
                content: Text(
                  'لقد حصلت على ${state.score} من ${state.totalQuestions}',
                  style: TextStyle(fontSize: 12.dp),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.pop();
                    },
                    child: const Text('حسناً'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.read<GamesBloc>().add(const RestartGame());
                    },
                    child: const Text('العب مرة أخرى'),
                  ),
                ],
              ),
            );
          }
        },
        child: BlocBuilder<GamesBloc, GamesState>(
          builder: (context, state) {
            if (state is GamesInitial) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('لعبة الأرقام'),
                  backgroundColor: Colors.blue.shade300,
                ),
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is GameCompleted && state.gameType == GameType.numbers) {
              final completedState = state;
              final question = completedState.lastQuestion;
              final count = question['count'] as int;
              final progress = 1.0;

              return Scaffold(
                appBar: AppBar(
                  title: const Text('لعبة الأرقام'),
                  backgroundColor: Colors.blue.shade300,
                ),
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue.shade100, Colors.cyan.shade100],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(5.w),
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue.shade400,
                            ),
                            minHeight: 2.h,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                'السؤال: ${completedState.totalQuestions}/${completedState.totalQuestions}',
                                style: TextStyle(
                                  fontSize: 12.dp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'النقاط: ${completedState.score}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: .all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withValues(alpha: 0.3),
                                  blurRadius: 5.w,
                                  spreadRadius: 1.w,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: .min,
                              children: [
                                Text(
                                  'كم عدد النجوم؟',
                                  style: TextStyle(
                                    fontSize: 14.dp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                    10,
                                    (index) => index < count
                                        ? const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 40,
                                          )
                                        : const SizedBox(
                                            width: 40,
                                            height: 40,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Expanded(
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.w,
                                mainAxisSpacing: 4.h,
                                childAspectRatio: 1.5,
                              ),
                              itemCount: (question['options'] as List).length,
                              itemBuilder: (context, index) {
                                final number =
                                    (question['options'] as List)[index] as int;

                                return GameOptionTile(
                                  mainText: number.toString(),
                                  subText: _getArabicNumber(number),
                                  isSelected: false,
                                  isCorrectOption: number == count,
                                  showResult: true,
                                  primaryColor: Colors.blue,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            if (state is! GameLoaded || state.gameType != GameType.numbers) {
              return const SizedBox.shrink();
            }

            final gameState = state;
            final question =
                gameState.questions[gameState.currentQuestionIndex];
            final count = question['count'] as int;
            final progress =
                (gameState.currentQuestionIndex + 1) /
                gameState.questions.length;

            return Scaffold(
              appBar: AppBar(
                title: const Text('لعبة الأرقام'),
                backgroundColor: Colors.blue.shade300,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade100, Colors.cyan.shade100],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: .all(5.w),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.shade400,
                          ),
                          minHeight: 10,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'السؤال: ${gameState.currentQuestionIndex + 1}/${gameState.questions.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'النقاط: ${gameState.score}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: .all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'كم عدد النجوم؟',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: List.generate(
                                  10,
                                  (index) => index < count
                                      ? const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 40,
                                        )
                                      : const SizedBox(width: 40, height: 40),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Expanded(
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4.w,
                              mainAxisSpacing: 4.h,
                              childAspectRatio: 1.5,
                            ),
                            itemCount: (question['options'] as List).length,
                            itemBuilder: (context, index) {
                              final number =
                                  (question['options'] as List)[index] as int;
                              final isSelected =
                                  gameState.selectedNumber == number;

                              return GestureDetector(
                                onTap: () {
                                  context.read<GamesBloc>().add(
                                    SelectNumber(number),
                                  );
                                },
                                child: GameOptionTile(
                                  mainText: number.toString(),
                                  subText: _getArabicNumber(number),
                                  isSelected: isSelected,
                                  isCorrectOption: number == count,
                                  showResult: gameState.showResult,
                                  primaryColor: Colors.blue,
                                ),
                              );
                            },
                          ),
                        ),
                        if (gameState.showResult)
                          Container(
                            padding: EdgeInsets.all(4.w),
                            margin: EdgeInsets.only(top: 2.h),
                            decoration: BoxDecoration(
                              color: gameState.isCorrect
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: Text(
                              gameState.isCorrect
                                  ? '🎉 ممتاز! إجابة صحيحة'
                                  : '😔 حاول مرة أخرى',
                              style: TextStyle(
                                fontSize: 12.dp,
                                fontWeight: FontWeight.bold,
                                color: gameState.isCorrect
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
