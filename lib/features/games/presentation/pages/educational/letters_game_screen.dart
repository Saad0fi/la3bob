import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/games_bloc.dart';
import '../../widgets/game_option_tile.dart';

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
                  title: const Text('לعبة الحروف'),
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
                      padding: EdgeInsets.all(5.w),
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
                          Text(
                            question['word'] as String,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'اختر الحرف الذي تبدأ به الكلمة',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.h),
                          GridView.builder(
                            shrinkWrap: true,
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
                              final letter =
                                  (question['options'] as List)[index]
                                      as String;
                              return GameOptionTile(
                                mainText: letter,
                                isSelected: false,
                                isCorrectOption: letter == question['letter'],
                                showResult: true,
                                primaryColor: Colors.purple,
                              );
                            },
                          ),
                          SizedBox(height: 2.h),
                        ],
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
                    padding: EdgeInsets.all(5.w),
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
                        Text(
                          question['word'] as String,
                          style: TextStyle(
                            fontSize: 28.dp,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'اختر الحرف الذي تبدأ به الكلمة',
                          style: TextStyle(
                            fontSize: 12.dp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
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
                              final letter =
                                  (question['options'] as List)[index]
                                      as String;
                              final isSelected =
                                  gameState.selectedLetter == letter;

                              return GestureDetector(
                                onTap: () {
                                  context.read<GamesBloc>().add(
                                        SelectLetter(letter),
                                      );
                                },
                                child: GameOptionTile(
                                  mainText: letter,
                                  isSelected: isSelected,
                                  isCorrectOption: letter == question['letter'],
                                  showResult: gameState.showResult,
                                  primaryColor: Colors.purple,
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

