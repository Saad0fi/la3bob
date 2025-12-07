import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:la3bob/features/profiles/presentation/screens/profile_screen.dart';
import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isBiometricSupported() async {
    return await _auth.isDeviceSupported();
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  static Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'الرجاء التحقق من الهوية للمتابعة',
        biometricOnly: false,
      );
      return didAuthenticate;
    } catch (e) {
      Fluttertoast.showToast(msg: "فشل التحقق  حاول مرة أخرى!");
      return false;
    }
  }

  static Future<void> goToProfilePage(BuildContext context) async {
    if (!await BiometricHelper.isBiometricSupported()) {
      Fluttertoast.showToast(msg: "الجهاز لا يدعم المصادقة.");
      return;
    }

    final availableBiometrics = await BiometricHelper.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) {
      Fluttertoast.showToast(
        msg:
            "لم يتم العثور على مصادقة بصمة أو وجه الرجاء إعدادها في اعدادات الجهاز .",
      );
      return;
    }

    final bool didAuthenticate = await BiometricHelper.authenticate();
    if (didAuthenticate && context.mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
    }
  }
}
