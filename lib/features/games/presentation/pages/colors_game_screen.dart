import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/features/games/presentation/bloc/games_bloc.dart';

class ColorsGameScreen extends StatelessWidget {
  const ColorsGameScreen({super.key});

  Color _getColorFromValue(int colorValue) {
    return Color(colorValue);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GamesBloc()..add(const InitializeColorsGame()),
      child: BlocListener<GamesBloc, GamesState>(
        listener: (context, state) {
          if (state is GameLoaded &&
              state.gameType == GameType.colors &&
              state.showResult) {
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                context.read<GamesBloc>().add(const MoveToNextQuestion());
              }
            });
          } else if (state is GameCompleted &&
              state.gameType == GameType.colors) {
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
                  title: const Text('لعبة الألوان'),
                  backgroundColor: Colors.orange.shade300,
                ),
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is GameCompleted && state.gameType == GameType.colors) {
              final completedState = state;
              final question = completedState.lastQuestion;
              final colorValue = question['colorValue'] as int;
              final progress = 1.0;

              return Scaffold(
                appBar: AppBar(
                  title: const Text('لعبة الألوان'),
                  backgroundColor: Colors.orange.shade300,
                ),
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.orange.shade100, Colors.red.shade100],
                    ),
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: .all(5.w),
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.orange.shade400,
                              ),
                              minHeight: 2.h,
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                color: _getColorFromValue(colorValue),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const SizedBox(width: 150, height: 150),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'ما اسم هذا اللون؟',
                              style: TextStyle(
                                fontSize: 14.dp,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.h),
                            Wrap(
                              spacing: 3.w,
                              runSpacing: 3.h,
                              alignment: WrapAlignment.center,
                              children: (question['options'] as List)
                                  .map<Widget>((colorName) {
                                    Color? backgroundColor;

                                    if (colorName == question['colorName']) {
                                      backgroundColor = Colors.green.shade300;
                                    } else {
                                      backgroundColor = Colors.grey.shade300;
                                    }

                                    return Container(
                                      width: 25.w,
                                      height: 10.h,
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: .circular(5.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2.w,
                                            spreadRadius: 0.5.w,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          colorName as String,
                                          style: TextStyle(
                                            fontSize: 14.dp,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                colorName ==
                                                    question['colorName']
                                                ? Colors.white
                                                : Colors.orange.shade700,
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            if (state is! GameLoaded || state.gameType != GameType.colors) {
              return const SizedBox.shrink();
            }

            final gameState = state;
            final question =
                gameState.questions[gameState.currentQuestionIndex];
            final colorValue = question['colorValue'] as int;
            final progress =
                (gameState.currentQuestionIndex + 1) /
                gameState.questions.length;

            return Scaffold(
              appBar: AppBar(
                title: const Text('لعبة الألوان'),
                backgroundColor: Colors.orange.shade300,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.orange.shade100, Colors.red.shade100],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange.shade400,
                          ),
                          minHeight: 10,
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'السؤال: ${gameState.currentQuestionIndex + 1}/${gameState.questions.length}',
                              style: TextStyle(
                                fontSize: 12.dp,
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
                            color: _getColorFromValue(colorValue),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const SizedBox(width: 150, height: 150),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'ما اسم هذا اللون؟',
                          style: TextStyle(
                            fontSize: 14.dp,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        Wrap(
                          spacing: 3.w,
                          runSpacing: 3.h,
                          alignment: WrapAlignment.center,
                          children: (question['options'] as List).map<Widget>((
                            colorName,
                          ) {
                            final isSelected =
                                gameState.selectedColor == colorName as String;
                            Color? backgroundColor;

                            if (gameState.showResult) {
                              if (colorName == question['colorName']) {
                                backgroundColor = Colors.green.shade300;
                              } else if (isSelected && !gameState.isCorrect) {
                                backgroundColor = Colors.red.shade300;
                              } else {
                                backgroundColor = Colors.grey.shade300;
                              }
                            } else {
                              backgroundColor = isSelected
                                  ? Colors.orange.shade300
                                  : Colors.white;
                            }

                            return GestureDetector(
                              onTap: () {
                                context.read<GamesBloc>().add(
                                  SelectColor(colorName),
                                );
                              },
                              child: Container(
                                width: 25.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: .circular(5.w),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 2.w,
                                      spreadRadius: 0.5.w,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    colorName,
                                    style: TextStyle(
                                      fontSize: 14.dp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          gameState.showResult &&
                                              colorName == question['colorName']
                                          ? Colors.white
                                          : Colors.orange.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (gameState.showResult)
                          Container(
                            padding: .all(4.w),
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              color: gameState.isCorrect
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: .circular(4.w),
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
