import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:la3bob/core/erors/failures/profiles_failures.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

abstract class ProfilesUtilityDataSource {
  Future<void> setSettingsProtection(String parentId, bool value);
  Future<bool?> getSettingsProtection(String parentId);

  Future<bool> authenticateBiometrics();
}

@Injectable(as: ProfilesUtilityDataSource)
class ProfilesUtilityDataSourceImpl implements ProfilesUtilityDataSource {
  final GetStorage _storage;
  final LocalAuthentication _auth;

  ProfilesUtilityDataSourceImpl(this._storage, this._auth);

  //  التخزين المحلي (GetStorage)
  static const String _baseKey = 'isSettingsProtected_';
  String _getScopedKey(String parentId) => '$_baseKey$parentId';

  @override
  Future<void> setSettingsProtection(String parentId, bool value) async {
    final key = _getScopedKey(parentId);
    await _storage.write(key, value);
  }

  @override
  Future<bool?> getSettingsProtection(String parentId) async {
    final key = _getScopedKey(parentId);
    return _storage.read(key) as bool?;
  }

  //  المصادقة البيومترية (LocalAuth)
  @override
  Future<bool> authenticateBiometrics() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        authMessages: <AuthMessages>[
          // تخصيص رسائل الأندرويد
          const AndroidAuthMessages(
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
      String errorMessage = "";

      //  حالات الإلغاء
      if (e.code == LocalAuthExceptionCode.userCanceled ||
          e.code == LocalAuthExceptionCode.systemCanceled ||
          e.code == LocalAuthExceptionCode.timeout ||
          e.code == LocalAuthExceptionCode.userRequestedFallback) {
        errorMessage = "تم إلغاء عملية التحقق";

        // حالات الفشل الأمني والتقني تتطلب تدخل المستخدم
      } else if (e.code == LocalAuthExceptionCode.noCredentialsSet ||
          e.code == LocalAuthExceptionCode.noBiometricsEnrolled ||
          e.code == LocalAuthExceptionCode.noBiometricHardware ||
          e.code == LocalAuthExceptionCode.temporaryLockout ||
          e.code == LocalAuthExceptionCode.biometricLockout) {
        errorMessage =
            "فشل التحقق! الرجاء إعداد قفل للشاشة (رمز مرور، بصمة، أو وجه) للمتابعة";
      }
      throw AuthbiometrecFailures(message: errorMessage);

      // أي خطأ غير معروف أو خطأ في الجهاز
    } catch (e) {
      throw AuthbiometrecFailures(
        message: "حدث خطأ  غير متوقع: ${e.toString()}",
      );
    }
  }
}
