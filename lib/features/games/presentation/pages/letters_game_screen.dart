import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/features/games/presentation/bloc/games_bloc.dart';

class LettersGameScreen extends StatelessWidget {
  const LettersGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GamesBloc()..add(const InitializeLettersGame()),
      child: BlocListener<GamesBloc, GamesState>(
        listener: (context, state) {
          if (state is GameLoaded &&
              state.gameType == GameType.letters &&
              state.showResult) {
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                context.read<GamesBloc>().add(const MoveToNextQuestion());
              }
            });
          } else if (state is GameCompleted &&
              state.gameType == GameType.letters) {
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
                  title: const Text('لعبة الحروف'),
                  backgroundColor: Colors.purple.shade300,
                ),
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is GameCompleted && state.gameType == GameType.letters) {
              final completedState = state;
              final question = completedState.lastQuestion;
              final progress = 1.0;

              return Scaffold(
                appBar: AppBar(
                  title: const Text('لعبة الحروف'),
                  backgroundColor: Colors.purple.shade300,
                ),
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.purple.shade100, Colors.pink.shade100],
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
                                Colors.purple.shade400,
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
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                question['word'] as String,
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Flexible(
                              child: Text(
                                'اختر الحرف الذي تبدأ به الكلمة',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Wrap(
                              spacing: 3.w,
                              runSpacing: 3.h,
                              alignment: WrapAlignment.center,
                              children: (question['options'] as List)
                                  .map<Widget>((letter) {
                                    Color? backgroundColor;

                                    if (letter == question['letter']) {
                                      backgroundColor = Colors.green.shade300;
                                    } else {
                                      backgroundColor = Colors.grey.shade300;
                                    }

                                    return Container(
                                      width: 20.w,
                                      height: 12.h,
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
                                          letter as String,
                                          style: TextStyle(
                                            fontSize: 24.dp,
                                            fontWeight: FontWeight.bold,
                                            color: letter == question['letter']
                                                ? Colors.white
                                                : Colors.purple.shade700,
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

            if (state is! GameLoaded || state.gameType != GameType.letters) {
              return const SizedBox.shrink();
            }

            final gameState = state;
            final question =
                gameState.questions[gameState.currentQuestionIndex];
            final progress =
                (gameState.currentQuestionIndex + 1) /
                gameState.questions.length;

            return Scaffold(
              appBar: AppBar(
                title: const Text('لعبة الحروف'),
                backgroundColor: Colors.purple.shade300,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.purple.shade100, Colors.pink.shade100],
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
                            Colors.purple.shade400,
                          ),
                          minHeight: 10,
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: .spaceBetween,
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
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            question['word'] as String,
                            style: TextStyle(
                              fontSize: 28.dp,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Flexible(
                          child: Text(
                            'اختر الحرف الذي تبدأ به الكلمة',
                            style: TextStyle(
                              fontSize: 12.dp,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Wrap(
                          spacing: 3.w,
                          runSpacing: 3.h,
                          alignment: WrapAlignment.center,
                          children: (question['options'] as List).map<Widget>((
                            letter,
                          ) {
                            final isSelected =
                                gameState.selectedLetter == letter as String;
                            Color? backgroundColor;

                            if (gameState.showResult) {
                              if (letter == question['letter']) {
                                backgroundColor = Colors.green.shade300;
                              } else if (isSelected && !gameState.isCorrect) {
                                backgroundColor = Colors.red.shade300;
                              } else {
                                backgroundColor = Colors.grey.shade300;
                              }
                            } else {
                              backgroundColor = isSelected
                                  ? Colors.purple.shade300
                                  : Colors.white;
                            }

                            return GestureDetector(
                              onTap: () {
                                context.read<GamesBloc>().add(
                                  SelectLetter(letter),
                                );
                              },
                              child: Container(
                                width: 20.w,
                                height: 12.h,
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
                                    letter,
                                    style: TextStyle(
                                      fontSize: 24.dp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          gameState.showResult &&
                                              letter == question['letter']
                                          ? Colors.white
                                          : Colors.purple.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 2.h),
                        if (gameState.showResult)
                          Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              color: gameState.isCorrect
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(15),
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
