import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      image: 'assets/images/onboarding1.png',
      title: 'انمو',
      description: 'ألعاب مثيرة تنمي الأطفال فكريا وتحفزهم',
    ),
    OnboardingItem(
      image: 'assets/images/onboarding2.png',
      title: 'تحرك',
      description: 'ألعاب تفاعلية حركية مرحة وجميلة مناسبة للأطفال',
    ),
    OnboardingItem(
      image: 'assets/images/onboarding3.png',
      title: 'تابع',
      description: 'يمكن للأطفال متابعة المقاطع بكل امان ويسر وسهولة',
    ),
  ];

  void _onNext() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    final box = GetStorage();
    box.write('seen_onboarding', true);
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundStart,
              AppColors.backgroundMiddle,
              AppColors.backgroundEnd,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Image.asset(item.image, fit: BoxFit.contain),
                          ),
                        ),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 24.dp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4C1D95),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.dp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_items.length, (dotIndex) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: _currentPage == dotIndex ? 3.w : 2.w,
                    height: _currentPage == dotIndex ? 3.w : 2.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == dotIndex
                          ? const Color(
                              0xFF8B5CF6,
                            ) 
                          : Colors.grey.shade300,
                    ),
                  );
                }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 7.h,
                      child: ElevatedButton(
                        onPressed: _onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 4,
                          shadowColor: AppColors.primary.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'التالي',
                          style: TextStyle(
                            fontSize: 18.dp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: Text(
                        'تخطي',
                        style: TextStyle(
                          fontSize: 16.dp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}
