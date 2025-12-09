import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:la3bob/features/profiles/presentation/screens/profile_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  // static Future<bool> isBiometricSupported() async {
  //   return await _auth.isDeviceSupported();
  // }

  // static Future<List<BiometricType>> getAvailableBiometrics() async {
  //   return await _auth.getAvailableBiometrics();
  // }

  static Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        authMessages: <AuthMessages>[
          // تخصيص رسائل الأندرويد
          AndroidAuthMessages(
            signInTitle: 'الرجاء التحقق من الهوية',
            signInHint: 'استخدم البصمة أو الوجه',
          ),
        ],
        localizedReason: 'الرجاء التحقق من الهوية للمتابعة',
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );
      return didAuthenticate;
    } on LocalAuthException catch (e) {
      print(e);
      //  حالات الإلغاء
      if (e.code == LocalAuthExceptionCode.userCanceled ||
          e.code == LocalAuthExceptionCode.systemCanceled ||
          e.code == LocalAuthExceptionCode.timeout ||
          e.code == LocalAuthExceptionCode.userRequestedFallback) {
        Fluttertoast.showToast(msg: "تم إلغاء عملية التحقق");

        // حالات الفشل الأمني والتقني تتطلب تدخل المستخدم
      } else if (e.code == LocalAuthExceptionCode.noCredentialsSet ||
          e.code == LocalAuthExceptionCode.noBiometricsEnrolled ||
          e.code == LocalAuthExceptionCode.noBiometricHardware ||
          e.code == LocalAuthExceptionCode.temporaryLockout ||
          e.code == LocalAuthExceptionCode.biometricLockout) {
        Fluttertoast.showToast(
          msg:
              "فشل التحقق! الرجاء إعداد قفل للشاشة (رمز مرور، بصمة، أو وجه) للمتابعة.",
        );

        // 3. أي خطأ غير معروف أو خطأ في الجهاز
      } else {
        Fluttertoast.showToast(
          msg: "فشل التحقق بسبب مشكلة فنية حاول مرة أخرى.",
        );
      }
      return false;
    }
  }

  static Future<void> goToProfilePage(BuildContext context) async {
    // if (!await BiometricHelper.isBiometricSupported()) {
    //   Fluttertoast.showToast(msg: "الجهاز لا يدعم المصادقة.");
    //   return;
    // }

    // final availableBiometrics = await BiometricHelper.getAvailableBiometrics();
    // if (availableBiometrics.isEmpty) {
    //   Fluttertoast.showToast(
    //     msg:
    //         "لم يتم العثور على مصادقة بصمة أو وجه الرجاء إعدادها في اعدادات الجهاز .",
    //   );
    //   return;
    // }

    final bool didAuthenticate = await BiometricHelper.authenticate();
    if (didAuthenticate && context.mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
    }
  }
}
