import 'package:flutter/material.dart';
import 'dart:math';

class LettersGameScreen extends StatelessWidget {
  const LettersGameScreen({super.key});

  static List<Map<String, dynamic>>? _cachedShuffledQuestions;
  static int _currentQuestionIndex = 0;
  static int _score = 0;
  static String? _selectedLetter;
  static bool _showResult = false;
  static bool _isCorrect = false;

  static const List<Map<String, dynamic>> questions = [
    {
      'word': 'تفاحة',
      'letter': 'ت',
      'options': ['ت', 'ب', 'ر', 'س'],
    },
    {
      'word': 'بطة',
      'letter': 'ب',
      'options': ['ب', 'ت', 'ج', 'د'],
    },
    {
      'word': 'جمل',
      'letter': 'ج',
      'options': ['ج', 'ح', 'خ', 'د'],
    },
    {
      'word': 'دب',
      'letter': 'د',
      'options': ['د', 'ذ', 'ر', 'ز'],
    },
    {
      'word': 'رمان',
      'letter': 'ر',
      'options': ['ر', 'ز', 'س', 'ش'],
    },
    {
      'word': 'سمكة',
      'letter': 'س',
      'options': ['س', 'ش', 'ص', 'ض'],
    },
    {
      'word': 'شمس',
      'letter': 'ش',
      'options': ['ش', 'ص', 'ض', 'ط'],
    },
    {
      'word': 'طائرة',
      'letter': 'ط',
      'options': ['ط', 'ظ', 'ع', 'غ'],
    },
    {
      'word': 'عصفور',
      'letter': 'ع',
      'options': ['ع', 'غ', 'ف', 'ق'],
    },
    {
      'word': 'فيل',
      'letter': 'ف',
      'options': ['ف', 'ق', 'ك', 'ل'],
    },
  ];

  void _shuffleOptions(List<Map<String, dynamic>> questions) {
    for (var question in questions) {
      final options = List<String>.from(question['options'] as List);
      options.shuffle(Random());
      question['options'] = options;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: StatefulBuilder(
            builder: (context, setState) {
              if (_cachedShuffledQuestions == null) {
                _cachedShuffledQuestions = questions
                    .map((q) => Map<String, dynamic>.from(q))
                    .toList();
                _shuffleOptions(_cachedShuffledQuestions!);
                _currentQuestionIndex = 0;
                _score = 0;
                _selectedLetter = null;
                _showResult = false;
                _isCorrect = false;
              }
              final shuffledQuestions = _cachedShuffledQuestions!;

              void selectLetter(String letter) {
                if (_showResult) return;

                setState(() {
                  _selectedLetter = letter;
                  final question = shuffledQuestions[_currentQuestionIndex];
                  _isCorrect = letter == question['letter'];
                  _showResult = true;

                  if (_isCorrect) {
                    _score++;
                  }
                });

                Future.delayed(const Duration(seconds: 2), () {
                  if (context.mounted) {
                    if (_currentQuestionIndex < shuffledQuestions.length - 1) {
                      setState(() {
                        _currentQuestionIndex++;
                        _selectedLetter = null;
                        _showResult = false;
                      });
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('🎉 ممتاز! 🎉'),
                          content: Text(
                            'لقد حصلت على $_score من ${shuffledQuestions.length}',
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('حسناً'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                _cachedShuffledQuestions = questions
                                    .map((q) => Map<String, dynamic>.from(q))
                                    .toList();
                                _shuffleOptions(_cachedShuffledQuestions!);
                                setState(() {
                                  _currentQuestionIndex = 0;
                                  _score = 0;
                                  _selectedLetter = null;
                                  _showResult = false;
                                });
                              },
                              child: const Text('العب مرة أخرى'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                });
              }

              final question = shuffledQuestions[_currentQuestionIndex];
              final progress =
                  (_currentQuestionIndex + 1) / shuffledQuestions.length;

              return Padding(
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'السؤال: ${_currentQuestionIndex + 1}/${shuffledQuestions.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'النقاط: $_score',
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
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'اختر الحرف الذي تبدأ به الكلمة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 1.5,
                            ),
                        itemCount: (question['options'] as List).length,
                        itemBuilder: (context, index) {
                          final letter =
                              (question['options'] as List)[index] as String;
                          final isSelected = _selectedLetter == letter;
                          Color? backgroundColor;

                          if (_showResult) {
                            if (letter == question['letter']) {
                              backgroundColor = Colors.green.shade300;
                            } else if (isSelected && !_isCorrect) {
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
                            onTap: () => selectLetter(letter),
                            child: Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        _showResult &&
                                            letter == question['letter']
                                        ? Colors.white
                                        : Colors.purple.shade700,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_showResult)
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: _isCorrect
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          _isCorrect
                              ? '🎉 ممتاز! إجابة صحيحة'
                              : '😔 حاول مرة أخرى',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _isCorrect
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
