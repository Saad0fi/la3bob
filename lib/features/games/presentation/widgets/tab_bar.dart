import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:la3bob/features/games/presentation/widgets/game_card.dart';

class EducationalGamesTab extends StatelessWidget {
  const EducationalGamesTab();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> eduGames = [
      {
        'title': 'الألوان',
        'route': '/tabs/games/colors',
        'image': 'assets/images/color.png',
        'color': const Color(0xFFF1F8E9),
      },
      {
        'title': 'الأرقام',
        'route': '/tabs/games/numbers',
        'image': 'assets/images/numbers.png',
        'color': const Color(0xFFF7F1FF),
      },
      {
        'title': 'الحروف',
        'route': '/tabs/games/letters',
        'image': 'assets/images/letters.png',
        'color': const Color(0xFFFFF3E0),
      },
      {
        'title': 'التطابق',
        'route': '/tabs/games/matching',
        'image': 'assets/images/matching.png',
        'color': const Color(0xFFE1F5FE),
      },
    ];

    return GridView.builder(
      padding: EdgeInsets.all(5.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
        childAspectRatio: 0.9,
      ),
      itemCount: eduGames.length,
      itemBuilder: (context, index) {
        final game = eduGames[index];
        return GameCard(
          title: game['title'],
          route: game['route'],
          imagePath: game['image'],
          backgroundColor: game['color'],
        );
      },
    );
  }
}

class PhysicalGamesTab extends StatelessWidget {
  const PhysicalGamesTab();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> phyGames = [
      {
        'title': 'القرفصاء',
        'route': '/games/squat',
        'image': 'assets/images/gamer.png',
        'color': const Color(0xFFF1F8E9),
      },
      {
        'title': 'القفز',
        'route': '/games/jump',
        'image': 'assets/images/long-jump.png',
        'color': const Color(0xFFF7F1FF),
      },
      {
        'title': 'أوامر القائد',
        'route': '/games/simon_says',
        'image': 'assets/images/command.png',
        'color': const Color(0xFFFFF3E0),
      },
      {
        'title': 'حركة حركة ستوب',
        'route': '/games/freeze',
        'image': 'assets/images/running.png',
        'color': const Color(0xFFE1F5FE),
      },
    ];

    return GridView.builder(
      padding: EdgeInsets.all(5.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
        childAspectRatio: 0.9,
      ),
      itemCount: phyGames.length,
      itemBuilder: (context, index) {
        final game = phyGames[index];
        return GameCard(
          title: game['title'],
          route: game['route'],
          imagePath: game['image'],
          backgroundColor: game['color'],
        );
      },
    );
  }
}
