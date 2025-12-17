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
      if (e.code == LocalAuthExceptionCode.userCanceled ||
          e.code == LocalAuthExceptionCode.systemCanceled ||
          e.code == LocalAuthExceptionCode.timeout ||
          e.code == LocalAuthExceptionCode.userRequestedFallback) {
        Fluttertoast.showToast(msg: "تم إلغاء عملية التحقق");
      } else if (e.code == LocalAuthExceptionCode.noCredentialsSet ||
          e.code == LocalAuthExceptionCode.noBiometricsEnrolled ||
          e.code == LocalAuthExceptionCode.noBiometricHardware ||
          e.code == LocalAuthExceptionCode.temporaryLockout ||
          e.code == LocalAuthExceptionCode.biometricLockout) {
        Fluttertoast.showToast(
          msg:
              "فشل التحقق! الرجاء إعداد قفل للشاشة (رمز مرور، بصمة، أو وجه) للمتابعة.",
        );
      } else {
        Fluttertoast.showToast(
          msg: "فشل التحقق بسبب مشكلة فنية حاول مرة أخرى.",
        );
      }
      return false;
    }
  }

  static Future<void> goToProfilePage(BuildContext context) async {
 
    final bool didAuthenticate = await BiometricHelper.authenticate();
    if (didAuthenticate && context.mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
    }
  }
}
