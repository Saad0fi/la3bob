import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class GameOptionTile extends StatelessWidget {
  const GameOptionTile({
    super.key,
    required this.mainText,
    this.subText,
    required this.isSelected,
    required this.isCorrectOption,
    required this.showResult,
    required this.primaryColor,
  });

  final String mainText;
  final String? subText;
  final bool isSelected;
  final bool isCorrectOption;
  final bool showResult;
  final MaterialColor primaryColor;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;

    if (showResult) {
      if (isCorrectOption) {
        backgroundColor = Colors.green.shade300;
      } else if (isSelected) {
        backgroundColor = Colors.red.shade300;
      } else {
        backgroundColor = Colors.grey.shade300;
      }
    } else {
      backgroundColor = isSelected ? primaryColor.shade300 : Colors.white;
    }

    final Color textColor =
        showResult && isCorrectOption ? Colors.white : primaryColor.shade700;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
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
              mainText,
              style: TextStyle(
                fontSize: 32.dp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            if (subText != null && subText!.isNotEmpty)
              Text(
                subText!,
                style: TextStyle(
                  fontSize: 14.dp,
                  color: textColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}


