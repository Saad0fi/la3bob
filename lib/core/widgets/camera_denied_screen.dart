import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../comon/theme/app_color.dart';

class CameraDeniedScreen extends StatelessWidget {
  const CameraDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.accent.withValues(alpha: .1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.videocam_off_rounded,
                        size: 15.w,
                        color: Colors.red.shade400,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),

                Text(
                  'الكاميرا غير مفعّلة',
                  style: TextStyle(
                    fontSize: 18.dp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'هذه اللعبة تحتاج الكاميرا لتتبع حركاتك.\nفعّل إذن الكاميرا من الإعدادات للاستمتاع باللعب!',
                    style: TextStyle(
                      fontSize: 12.dp,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 5.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await openAppSettings();
                    },
                    icon: const Icon(Icons.settings, color: Colors.white),
                    label: Text(
                      'فتح الإعدادات',
                      style: TextStyle(
                        fontSize: 12.dp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: EdgeInsets.all(2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/tabs/games'),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.textSecondary,
                    ),
                    label: Text(
                      'الرجوع للألعاب',
                      style: TextStyle(
                        fontSize: 12.dp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),

                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.accent,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'بعد تفعيل الإذن، ارجع للتطبيق وستعمل الكاميرا تلقائياً',
                          style: TextStyle(
                            fontSize: 10.dp,
                            color: AppColors.accent,
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
      ),
    );
  }
}

