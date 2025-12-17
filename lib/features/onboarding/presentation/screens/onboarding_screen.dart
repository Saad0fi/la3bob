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
    // الصفحة الأولى (التعريفية - البيانات هنا لا تهم لأننا سنخصص تصميمها في الأسفل)
    OnboardingItem(
      image: 'assets/images/logo_la3bob.png',
      title: 'WELCOME',
      description: '',
    ),
    OnboardingItem(
      image: 'assets/images/onboarding1.png',
      title: 'انمو',
      description:
          'ألعاب مثيرة تنمي الأطفال فكريا وتحفزهم على الإبداع والاكتشاف.',
    ),
    OnboardingItem(
      image: 'assets/images/onboarding2.png',
      title: 'تحرك',
      description:
          'ألعاب تفاعلية حركية مرحة تشجع الطفل على النشاط البدني بطريقة ذكية.',
    ),
    OnboardingItem(
      image: 'assets/images/onboarding3.png',
      title: 'تابع',
      description:
          'يمكن للأطفال متابعة المقاطع بكل أمان ويسر تحت إشراف كامل من الوالدين.',
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

                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              item.image,
                              width: 50.w,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 3.h),

                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'أهلاً بك في ',
                                    style: TextStyle(
                                      fontSize: 24.dp,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'لعبوب',
                                    style: TextStyle(
                                      fontSize: 26.dp,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              "منصتك الآمنة للترفيه والتعليم",
                              style: TextStyle(
                                fontSize: 17.dp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),

                            Container(
                              padding: EdgeInsets.all(5.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  _buildFeatureRow(
                                    icon: Icons.video_library_rounded,
                                    text: "مكتبة فيديوهات آمنة ومفلترة",
                                  ),
                                  SizedBox(height: 2.h),
                                  _buildFeatureRow(
                                    icon: Icons.games_rounded,
                                    text: "ألعاب تعليمية وتفاعلية للمهارات",
                                  ),
                                  SizedBox(height: 2.h),
                                  _buildFeatureRow(
                                    icon: Icons.admin_panel_settings_rounded,
                                    text: "لوحة تحكم شاملة للوالدين",
                                  ),
                                  SizedBox(height: 2.h),
                                  _buildFeatureRow(
                                    icon: Icons.category_rounded,
                                    text: "محتوى متنوع (ديني، قيمي، ترفيهي)",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // ---------------------------------------------------------
                    // تصميم باقي الصفحات (انمو، تحرك، تابع) - كما هي
                    // ---------------------------------------------------------
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Image.asset(item.image, fit: BoxFit.contain),
                          ),
                        ),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 26.dp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17.dp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_items.length, (dotIndex) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: _currentPage == dotIndex ? 8.w : 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _currentPage == dotIndex
                          ? AppColors.primary
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
                          elevation: 5,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          _currentPage == _items.length - 1
                              ? 'انطلق الآن'
                              : 'التالي',
                          style: TextStyle(
                            fontSize: 18.dp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: Text(
                        'تخطي المقدمة',
                        style: TextStyle(
                          fontSize: 15.dp,
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

  Widget _buildFeatureRow({required IconData icon, required String text}) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 5.w),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 14.dp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
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
