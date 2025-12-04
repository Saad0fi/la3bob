import 'package:flutter/material.dart';
import 'dart:math';

class NumbersGameScreen extends StatelessWidget {
  const NumbersGameScreen({super.key});

  static List<Map<String, dynamic>>? _cachedShuffledQuestions;
  static int _currentQuestionIndex = 0;
  static int _score = 0;
  static int? _selectedNumber;
  static bool _showResult = false;
  static bool _isCorrect = false;

  static const List<Map<String, dynamic>> questions = [
    {
      'count': 1,
      'options': [1, 2, 3, 4],
    },
    {
      'count': 2,
      'options': [2, 3, 4, 5],
    },
    {
      'count': 3,
      'options': [3, 4, 5, 6],
    },
    {
      'count': 4,
      'options': [2, 3, 4, 5],
    },
    {
      'count': 5,
      'options': [4, 5, 6, 7],
    },
    {
      'count': 6,
      'options': [5, 6, 7, 8],
    },
    {
      'count': 7,
      'options': [6, 7, 8, 9],
    },
    {
      'count': 8,
      'options': [7, 8, 9, 10],
    },
    {
      'count': 9,
      'options': [8, 9, 10, 11],
    },
    {
      'count': 10,
      'options': [9, 10, 11, 12],
    },
  ];

  void _shuffleOptions(List<Map<String, dynamic>> questions) {
    for (var question in questions) {
      final options = List<int>.from(question['options'] as List);
      options.shuffle(Random());
      question['options'] = options;
    }
  }

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
    final shuffledQuestions = questions.map((q) => Map<String, dynamic>.from(q)).toList();
    _shuffleOptions(shuffledQuestions);

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
            colors: [
              Colors.blue.shade100,
              Colors.cyan.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
              if (_cachedShuffledQuestions == null) {
                _cachedShuffledQuestions = questions.map((q) => Map<String, dynamic>.from(q)).toList();
                _shuffleOptions(_cachedShuffledQuestions!);
                _currentQuestionIndex = 0;
                _score = 0;
                _selectedNumber = null;
                _showResult = false;
                _isCorrect = false;
              }
              final shuffledQuestions = _cachedShuffledQuestions!;

              void selectNumber(int number) {
                if (_showResult) return;

                setState(() {
                  _selectedNumber = number;
                  final question = shuffledQuestions[_currentQuestionIndex];
                  _isCorrect = number == question['count'];
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
                        _selectedNumber = null;
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
                                _cachedShuffledQuestions = questions.map((q) => Map<String, dynamic>.from(q)).toList();
                                _shuffleOptions(_cachedShuffledQuestions!);
                                setState(() {
                                  _currentQuestionIndex = 0;
                                  _score = 0;
                                  _selectedNumber = null;
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
              final count = question['count'] as int;
              final progress = (_currentQuestionIndex + 1) / shuffledQuestions.length;

              return Padding(
                padding: const EdgeInsets.all(20.0),
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
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
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
                    const SizedBox(height: 40),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: (question['options'] as List).length,
                        itemBuilder: (context, index) {
                          final number = (question['options'] as List)[index] as int;
                          final isSelected = _selectedNumber == number;
                          Color? backgroundColor;

                          if (_showResult) {
                            if (number == count) {
                              backgroundColor = Colors.green.shade300;
                            } else if (isSelected && !_isCorrect) {
                              backgroundColor = Colors.red.shade300;
                            } else {
                              backgroundColor = Colors.grey.shade300;
                            }
                          } else {
                            backgroundColor = isSelected
                                ? Colors.blue.shade300
                                : Colors.white;
                          }

                          return GestureDetector(
                            onTap: () => selectNumber(number),
                            child: Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      number.toString(),
                                      style: TextStyle(
                                        fontSize: 56,
                                        fontWeight: FontWeight.bold,
                                        color: _showResult && number == count
                                            ? Colors.white
                                            : Colors.blue.shade700,
                                      ),
                                    ),
                                    Text(
                                      _getArabicNumber(number),
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: _showResult && number == count
                                            ? Colors.white
                                            : Colors.blue.shade700,
                                      ),
                                    ),
                                  ],
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
                          color: _isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          _isCorrect ? '🎉 ممتاز! إجابة صحيحة' : '😔 حاول مرة أخرى',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _isCorrect ? Colors.green.shade800 : Colors.red.shade800,
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
